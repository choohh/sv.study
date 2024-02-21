- **Two types of device defined for I2C** : Master & Slave

- **Two types of line between master and slave** : SCL & SDA

- SCL은 Master가 보내는 clock 신호 (Only Master -> Slave),
<br>SDA는 실제 데이터와 START, ACK 등 송수신 확인에 필요한 신호를 전송하는 버스 (Master -> Slave or Slave -> Master)

- 그렇기 때문에 04_I2C_dut.v에서 module i2c_Master는 input으로 clk을 받고 output으로 scl을 내보내지만,
<br>module i2c_Slave는 scl을 input으로 받는다.
<br>다시 말해 master에서 scl과 sda에 어떤 값을 넣어주는지가 clk을 기준으로 결정된다. (정확히는 pulse)
<br>하지만 slave에서는 sda에 어떤 값을 넣어주는지가 scl을 기준으로 결정된다.

- Master와 Slave에서 각각 정의된 state의 종류는 아래와 같다. 두 모듈의 상태는 항상 아래의 9가지 중 하나이다.
<br>대체로 다 직관적인데, ack_1과 ack_2의 차이는 slave가 address를 받았느냐, data를 받았느냐의 차이이다.
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
| idle  | Content Cell  | 
| start  | Content Cell  |  
| write_addr  | Content Cell  | 
| ack_1  | Content Cell  |
| write_data  | Content Cell  | 
| read_data  | Content Cell  |
| stop  | Content Cell  |
| ack_2  | Content Cell  | 
| master_ack  | Content Cell  | 

</td><td>

| State  | Description |
|---|---|
| idle  | Content Cell  | 
| read_addr  | Content Cell  |  
| send_ack1  | Content Cell  | 
| send_data  | Content Cell  |
| master_ack  | Content Cell  | 
| read_data | Content Cell  |
| send_ack2  | Content Cell  |
| wait_p  | Content Cell  | 
| detect_stop  | Content Cell  | 

</td></tr> </table>
