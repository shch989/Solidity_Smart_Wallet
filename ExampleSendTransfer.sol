// SPDX-License-Identifier: MIT
// pragma solidity 0.8.15;

// Sender 컨트랙트 정의
contract Sender {
    
    // receive 함수: 이 컨트랙트로 직접 Ether를 전송할 때 호출됩니다.
    receive() external payable {}

    // Ether를 다른 주소로 전송하는 함수 (transfer를 사용)
    function withdrawTransfer(address payable _to) public {
        _to.transfer(10); // 10 Wei를 지정된 주소로 전송합니다.
    }

    // Ether를 다른 주소로 전송하는 함수 (send를 사용)
    function withdrawSend(address payable _to) public {
        bool isSent = _to.send(10); // 10 Wei를 지정된 주소로 전송하고 성공 여부를 확인합니다.

        require(isSent, "Sending the funds was unsuccessful"); // 전송이 실패한 경우 예외를 발생시킵니다.
    }
}

// ReceiverNoAction 컨트랙트 정의
contract ReceiverNoAction {

    // 현재 컨트랙트의 잔액을 조회하는 함수
    function balance() public view returns(uint) {
        return address(this).balance;
    }

    // receive 함수: 이 컨트랙트로 직접 Ether를 전송할 때 호출됩니다.
    receive() external payable {}
}

// ReceiverAction 컨트랙트 정의
contract ReceiverAction {
    uint public balanceReceived;

    // receive 함수: 이 컨트랙트로 직접 Ether를 전송할 때 호출됩니다.
    receive() external payable {
        balanceReceived += msg.value; // 전송된 Ether 금액을 저장합니다.
    } 
    
    // 현재 컨트랙트의 잔액을 조회하는 함수
    function balance() public view returns(uint) {
        return address(this).balance;
    }
}