- **Two types of device defined for I2C** : Master & Slave

- **Two types of line between master and slave** : SCL & SDA

- SCL은 Master가 보내는 clock 신호 (Only Master -> Slave),
<br>SDA는 실제 데이터와 START, ACK 등 송수신 확인에 필요한 신호를 전송하는 버스 (Master -> Slave or Slave -> Master)

- 그렇기 때문에 04_I2C_dut.v에서 module i2c_Master는 input으로 clk을 받고 output으로 scl을 내보내지만,
<br>module i2c_Slave는 scl을 input으로 받는다.
<br>다시 말해 master에서 scl과 sda에 어떤 값을 넣어주는지가 clk을 기준으로 결정된다. (정확히는 pulse)
<br>하지만 slave에서는 sda에 어떤 값을 넣어주는지가 scl을 기준으로 결정된다.

- Master와 Slave에서 각각 정의된 state의 종류는 아래와 같다. 두 모듈의 상태는 항상 아래의 9가지 중 하나이다.
<br>대체로 다 직관적인데, ack_1과 ack_2의 차이가 헷갈릴 수 있다. 이 둘은 slave가 address를 받았느냐, data를 받았느냐에 따라 나뉜다.
<br>ack는 기본적으로 master가 slave에 뭔가 보냈을 때, slave가 "나 제대로 받았어!"라는 뜻에서 보내는 확인 신호이다.
<br>04_I2C_dut.v에서 slave는 메모리이고, 따라서 메모리에 데이터를 저장할 때 먼저 주소를 보낸 후 데이터를 보내야 하는데,
<br>주소를 보냈을 때 slave가 "잘 받았음!"이라고 하는게 ack_1, 그 다음으로 데이터를 보냈을 때 "잘 받았음!"이라고 하는게 ack_2인 것이다.

- 그리고 04_I2C_dut에서는 사실 start와 stop 신호를 진짜로 detect하지 않는다.
<br>그냥 그 사이클에서는 slave가 당연히 start 또는 stop이 들어온다고 생각하고 거기에 대응되는 작업을 하는데,
<br>이 state가 start의 경우 p_wait, stop의 경우 detect_stop이다.
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
| read_data  | slave에게 주소를 보내고<br>그 주소에 저장된데이터 요청 |
| stop  | slave에게 통신 종료 알림 |
| ack_2  | slave가 저장할 데이터 잘 받았는지 응답 확인   | 
| master_ack  | slave에게 보내준 데이터 잘 받았다고 확인<br>이 확인은 I2C에서 NACK으로 하도록 규정됨  | 

</td><td>

| State  | Description |
|---|---|
| idle  | 이무것도 안 하고 있는 상태  | 
| read_addr  | Master가 보내준 주소 수신  |  
| send_ack1  | Master에게 주소 잘 받았다고 신호 송신  | 
| send_data  | Master에게 받은 주소에 해당하는 데이터 송신  |
| master_ack  | Master가 데이터 잘 받았는지 응답 확인  | 
| read_data | Master가 저장하라고 보낸 데이터 수신 |
| send_ack2  | Master에게 데이터 잘 받았다고 신호 송신  |
| wait_p  |  | start를 받는 기간인데
| detect_stop  | Master가 보내는 통신 종료 신호 확인  | 

</td></tr> </table>
