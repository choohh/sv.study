# I2C 코드 분석
## 1. 04_I2C_dut.v
- **Two types of device defined for I2C** : Master & Slave

- **Two types of line between master and slave** : SCL & SDA

- SCL은 Master가 보내는 clock 신호 (Only Master -> Slave),
<br>SDA는 실제 데이터와 START, ACK 등 송수신 확인에 필요한 신호를 전송하는 버스 (Master -> Slave or Slave -> Master)

- ***(주의!!)*** 그렇기 때문에 원래는 master가 input으로 clk를 받고 output으로 scl을 내보내면 slave가 scl을 input으로 받아야 하지만,
<br>04_I2C_dut.v에서는 start, stop 신호를 받을 때를 제외하고는 각자 clk으로부터 pulse를 생성해서 쓴다.
<br>즉 실제 I2C 구성을 그대로 구현하지 않고, 동일한 clk을 master와 slave에 동시에 입력해서
<br>원래 I2C 구성과 같은 결과가 나오도록 만들어 놓은 것 같다.
<br>I2C 구현이 아니라 검증을 가르치는 것이 목적이기 때문에, 최대한 간단한 형태로 DUT를 구현하느라 이런 편법(?)을 쓴 것이 아닐까 싶다. 

- Master와 Slave에서 각각 정의된 state의 종류는 아래와 같다. 두 모듈의 상태는 항상 아래의 9가지 중 하나이다.
<br>대체로 다 직관적인데, ack_1과 ack_2의 차이가 헷갈릴 수 있다. 이 둘은 slave가 address를 받았느냐, data를 받았느냐에 따라 나뉜다.
<br>ack는 기본적으로 master가 slave에 뭔가 보냈을 때, slave가 "나 제대로 받았어!"라는 뜻에서 보내는 확인 신호이다.
<br>04_I2C_dut.v에서 slave는 메모리이고, 따라서 메모리에 데이터를 저장할 때 먼저 주소를 보낸 후 데이터를 보내야 하는데,
<br>주소를 보냈을 때 slave가 "잘 받았음!"이라고 하는게 ack_1, 그 다음으로 데이터를 보냈을 때 "잘 받았음!"이라고 하는게 ack_2인 것이다.
　<table>
<tr><th>Master 
</th><th>Slave
</th></tr>
<tr><td>

| State  | Description |
|---|---|
| idle  | 아무것도 안 하고 있는 상태 | 
| start  | slave에게 통신 시작 알림 |  
| write_addr  | slave에게 데이터를 저장할 주소값 송신  | 
| ack_1  | slave가 주소값 잘 받았는지 응답 확인  |
| write_data  | ack_1 확인 후, slave에게<br> 그 주소에 저장할 데이터 송신 | 
| read_data  | slave에게 주소를 보내고<br>그 주소에 저장된 데이터 요청 |
| stop  | slave에게 통신 종료 알림 |
| ack_2  | slave가 저장할 데이터 잘 받았는지 응답 확인   | 
| master_ack  | slave에게 보내준 데이터 잘 받았다고 확인<br>이 확인은 I2C에서 NACK으로 하도록 규정됨  | 

</td><td>

| State  | Description |
|---|---|
| idle  | 아무것도 안 하고 있는 상태  | 
| read_addr  | Master가 보내준 주소 수신  |  
| send_ack1  | Master에게 주소 잘 받았다고 신호 송신  | 
| send_data  | Master에게 받은 주소에 해당하는 데이터 송신  |
| master_ack  | Master가 데이터 잘 받았는지 응답 확인  | 
| read_data | Master가 저장하라고 보낸 데이터 수신 |
| send_ack2  | Master에게 데이터 잘 받았다고 신호 송신  |
| wait_p | start 감지한 직후 pulse cycle 시작까지 대기 |
| detect_stop  | Master가 보내는 통신 종료 신호 확인  | 

</td></tr> </table>

## 2. 04_I2C_tb.sv
master는 딱 두 가지 동작만을 실시한다: write와 read.
constraint randomization을 통해 address와 
