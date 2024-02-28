# AXI 

## 1. 개요

**"Advanced eXtensible Interface"** 
<br>ARM에서 정의한 On-chip bus protocol이다.
<br>
<br>AXI는 _기본적으로_ 5개의 독립적인 channel로 구성되고, 각 채널은 다시 여러 개의(꽤 많은..) signal로 구성된다.
<br>이 5개의 채널은 **write request(AW), write data(W), write response(B), read request(AR), read data(R)** 이다.
<br>여기에 더해 ACLK, ARESET 등 어떤 채널에도 속하지 않은 Interface level signal 몇 개가 더 있다.
<br>
<br>(Snoop channel도 존재하지만, AXI에서 필수 요소는 아니다.
<br>이건 DVM(Distributed Virtual Memory) message 송수신에 쓰이는데, 이는 주로 cache coherence를 위해 사용되는 기능이다.)
<br><br>

## 2. 단계별 작동 원리

### 2-1. Handshake
모든 전송은 Handshake를 한 후에 시작된다. Handshake란 source와 destination이 각각 데이터를 보낼 준비, 받을 준비가 되었다고 
<br>서로 확인해주는 단계이다. 이 때 source와 destination은 (master, slave) 쌍일 수도 있고 (slave, master) 쌍일 수도 있다.
<br>Handshake는 READY, VALID 두 개의 signal을 통해 이루어진다.
<br>Source는 데이터가 준비되어 해당 signal로 입력할 때 VALID도 HIGH로 바꿔준다. Dest.는 받을 수 있으면 READY를 HIGH로 바꿔준다.
<br>VALID와 READY가 모두 HIGH일 때만 데이터가 수신된다.
<br>이 때 READY와 VALID 둘 중에 무엇이 앞서도 상관 없다. (FIG A3.2, 3.3, 3.4)
<br>

### 2-1. Read


### 2-2. Write
