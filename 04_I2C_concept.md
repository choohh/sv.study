**Two types of device defined for I2C** : Master & Slave

**Two types of line between master and slave** : SCL & SDA

SCL은 Master가 보내는 clock 신호 (Only Master -> Slave),
<br>SDA는 실제 데이터와 START, ACK 등 송수신 확인에 필요한 신호를 전송하는 버스 (Master -> Slave or Slave -> Master)

그렇기 때문에 04_I2C_dut.v에서 module master는 input으로 clk을 받고 output으로 scl을 내보내지만,
<br>module slave는 scl을 input으로 받는다.
<br>다시 말해 master에서 scl과 sda에 어떤 값을 넣어주는지가 clk을 기준으로 결정된다. (정확히는 pulse)
<br>하지만 slave에서는 sda에 어떤 값을 넣어주는지가 scl을 기준으로 결정된다.
