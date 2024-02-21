Two types of device defined for I2C : Master & Slave

Two types of line between master and slave : SCL & SDA

SCL은 Master가 보내는 clock 신호 (Only Master -> Slave),
<br>SDA는 실제 데이터와 START, ACK 등 송수신 확인에 필요한 신호를 전송하는 버스 (Master -> Slave or Slave -> Master)
