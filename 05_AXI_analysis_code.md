# AXI 코드 분석
## 1. 05_AXI_dut.v
### 1-1. 개요
- 04_I2C_dut.v와 달리 05_AXI_dut.v는 slave만을 구현해놨다.
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
- write request

|State|Description|
|-----|------|
| awidle | 아무것도 안 하고 있는 상태 |
| awstart|  |
| awreadys | |

- write

|State|Description|
|-----|------|
| widle |  |
| wstart|  |
| wreadys | |
|wvalids||
|waddr_dec||

- write response

|State|Description|
|-----|------|
| bidle |  |
| bdetect_last|  |
| bstart | |
| bwait ||

- read

|State|Description|
|-----|------|
| aridle |  |
| arstart|  |
| arreadys | |

- read response

|State|Description|
|-----|------|
| ridle |  |
| rstart|  |
| rwait | |
|rvalids||
|rerror||

## 2. 05_AXI_tb.sv
