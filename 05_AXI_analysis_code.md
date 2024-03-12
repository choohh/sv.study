# AXI 코드 분석
## 1. 05_AXI_dut.v
### 1-1. 개요
- 04_I2C_dut.v와 달리 05_AXI_dut.v는 slave만을 구현해놨다.<br>
즉 master와 slave로 구성된 AXI 시스템을 검증하는 것이 아니라, AXI를 통해 master와 통신하는 slave를 검증하는 프로젝트이다.<br>
기본적으로 5개의 채널(write request, write, write response, read request, read)에 대해 각각 FSM이 구현되어 있다.<br>
- 각 채널에 대한 FSM에 존재하는 state 목록은 다음과 같다.<br>

|Channel|State|No. of state|
|-----|------|---|
| write request | awidle, awstart, awreadys |3|
| write | widle, wstart, wreadys, wvalids, waddr_dec |5|
| write response |bidle, bdetect_last, bstart, bwait|4|
| read request |aridle, arstart, arreadys|3|
|read |ridle, rstart, rwait, rvalids, rerror|5|

### 1-2. 각 채널의 state 분석
- 모든 state는 slave 입장에서 바라봐야 한다는 점을 기억하자.
- posedge clk에 next_state로 바뀐다. 즉 cycle 단위로 갱신된다.<br><br>
- **write request**

|State|Description|
|-----|------|
| awidle | awready를 LOW로 낮추고 기다린다. 바로 다음 사이클에 awstart로 넘어간다.<br>즉 이 상태는 idle이라기보다는 init에 더 가깝다. |
| awstart| master가 awvalid를 HIGH로 바꾸고 대기중인 상태라면 addr을 받는다.  |
| awreadys | awready를 HIGH로 올리고 다음 clk posedge에 idle로 돌아간다. |

- **write**<br>
write 채널을 위해서 이 코드에는 data_wr_fixed, data_wr_incr, data_wr_wrap이라는 function 3개가 있다.
<br>이는 burst 옵션에 따라 next addr.이 무엇이 될지 리턴해주는 함수로, wreadys 상태에서 사용된다.

|State|Description|
|-----|------|
| widle | wready를 LOW로 낮추고 기다린다. 바로 다음 사이클에 wstart로 넘어간다.<br>즉 이 상태는 idle이라기보다는 init에 더 가깝다. |
| wstart| master가 wvalid를 HIGH로 바꾸고 대기중인 상태라면 wdata를 받는다.<br>nextaddr을 받기 위해 waddr_dec 상태로 넘어간다.|
|waddr_dec| write request 이후 첫 전송이라면 first=0이라 nextaddr로 addr을 그대로 쓰고, <br>아니라면 nextaddr로 계산해놓은 retaddr을 쓴다. <br>이 retaddr은 wreadys 상태에서 미리 선언된 data_wr_* 함수를 통해 계산된다.|
| wreadys | data_wr_*을 통해 mem의 해당 주소 공간에 받은 wdata를 쓴다. 동시에 (늦었지만) ready를 HIGH로 올린다. |
|wvalids| wlen_count를 1 올리고 wstart 상태로 돌아간다. |

- **write response**

|State|Description|
|-----|------|
| bidle | 마찬가지로 idle이라기보다는 init에 더 가깝다. <br>bresp를 디폴트값인 0으로 세팅해놓고 bdetect_last로 넘어간다. |
| bdetect_last| wlast가 1이 될 때까지 기다린다. wlast가 1이 되면 bstart로 넘어간다. |
| bstart | 실제로 데이터를 잘 받았는지 체크한다. 원래 bresp에는 EXAOKAY도 있는데, <br>05_AXI_dut.v에서는 그걸 빼고 3가지만 구현해놨다.<br>(1)okay(00): 아무 문제 없음<br>(2)slverr(10): slave까지 전송은 잘 됐으나 slave 내부에서 모종의 이유로 에러가 생김.<br>05_AXI_dut.v의 경우에는 burst를 1,2,4번 중 골라야 하는데,<br>AWSIZE가 3보다 크면 선택 범위를 넘어가 이 에러가 뜬다.<br>(3) decerr(11): addr가 mem이 가진 주소보다 클 때 발생하는 에러|
| bwait |master가 잘 받았는지 bvalid 신호를 확인하다가 HIGH가 되면 다음 cycle에 bidle로 넘어간다.|

- **read request**

|State|Description|
|-----|------|
| aridle | arready를 LOW로 낮추고 기다린다. 바로 다음 사이클에 arstart로 넘어간다.<br>즉 이 상태는 idle이라기보다는 init에 더 가깝다. |
| arstart| master가 arvalid를 HIGH로 바꾸고 대기중인 상태라면 addr을 받는다. |
| arreadys | arready를 HIGH로 올리고 다음 clk posedge에 idle로 돌아간다. |

- **read**<br>
write 채널을 위해서 이 코드에는 read_data_fixed, read_data_incr, read_data_wrap이라는 function 3개가 있다.
<br>이는 burst 옵션에 따라 next addr.이 무엇이 될지 리턴해주는 함수로, rstart 상태에서 사용된다.

|State|Description|
|-----|------|
| ridle | read의 경우에는 정말 idle 상태이다. arvalid가 HIGH가 되어야 rstart로 넘어간다.  |
| rstart| rvalid를 HIGH로 올리고 위에서 설명한 함수를 통해 mem에서 데이터를 읽어온다.<br>read는 따로 response 채널이 없기 때문에 이 상태에서 resp도 정한다.<br>디폴트는 00(okay)이고 write의 경우와 마찬가지로 burst 횟수가 4를 초과하면 10,<br>없는 주소에 대해 read를 요청하면 11이 rresp 값이 된다.<br>이렇게 에러가 생기면 rerror로 이동한다. 아니라면<br> rwait으로 이동한다. |
| rwait | len_count와 rlast를 업데이트한다. 만약 전송이 끝났다면 rlast를 HIGH로 바꾼다.<br>rready가 HIGH가 될 때까지, 즉 master로부터 잘 받았다는 신호가 올 때까지 기다린다. <br>신호를 확인하면 rvalids로 간다. |
|rvalids| 한 사이클 후에 ridle 또는 rstart로 이동시킨다. |
|rerror| rerror 상태가 존재하는 이유는 애초에 read를 못 했으니 master로부터의 rready를 기다릴 필요가 없기 때문이다.<br> 바로 rstart로 가서 다음 전송을 시작하거나 전송이 끝났으면 ridle로 이동한다. |

## 2. 05_AXI_tb.sv
