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
- **write request**

|State|Description|
|-----|------|
| awidle | awready를 LOW로 낮추고 기다린다. |
| awstart| master가 awvalid를 HIGH로 바꾸고 대기중인 상태라면 addr을 받는다.  |
| awreadys | awready를 HIGH로 올리고 다음 clk posedge에 idle로 돌아간다. <br>사실 원래 ready가 먼저 HIGH로 올라가고 그것이 Trigger가 돼서 addr을 받아야 하는데,<br>이 코드에서는 순서가 바뀌어 있다.|

- **write**<br>
write 채널을 위해서 이 코드에는 data_wr_fixed, data_wr_incr, data_wr_wrap이라는 function 3개가 있다.
<br>이는 burst 옵션에 따라 next addr.이 무엇이 될지 리턴해주는 함수로, wreadys 상태에서 사용된다.

|State|Description|
|-----|------|
| widle |  |
| wstart|  |
| wreadys | |
|wvalids||
|waddr_dec||

- **write response**

|State|Description|
|-----|------|
| bidle |  |
| bdetect_last|  |
| bstart | |
| bwait ||

- **read**

|State|Description|
|-----|------|
| aridle |  |
| arstart|  |
| arreadys | |

- **read response**

|State|Description|
|-----|------|
| ridle |  |
| rstart|  |
| rwait | |
|rvalids||
|rerror||

## 2. 05_AXI_tb.sv
