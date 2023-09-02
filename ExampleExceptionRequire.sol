// SPDX-License-Identifier: MIT
// pragma solidity 0.7.0;

contract ExampleExceptionRequire {
    
    // 사용자 주소별 잔액을 저장하는 매핑
    mapping (address => uint8) public balanceReceived;

    // Ether를 받는 함수
    function receiveMoney() public payable {
        assert(msg.value == uint8(msg.value)); // (예외처리)송금된 Ether 값이 uint8 범위 내에 있는지 확인
        balanceReceived[msg.sender] += uint8(msg.value); // 송금자의 잔액에 Ether 추가
    }

    // 사용자 간에 Ether를 송금하는 함수
    function withdrawMoney(address payable _to, uint8 _amount) public {
        require(_amount <= balanceReceived[msg.sender], "Not enough funds, aborting!"); // (예외처리)충분한 잔액 확인

        balanceReceived[msg.sender] -= _amount; // 송금자의 잔액에서 송금액 감소
        _to.transfer(_amount); // 지정된 주소로 Ether 전송
    }
}
