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

## 2. 동작별 작동 원리

### 2-1. Read


### 2-2. Write
