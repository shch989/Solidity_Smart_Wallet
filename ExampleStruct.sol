// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// PaymentReceived 컨트랙트 정의
contract PaymentReceived {
    address public from; // 송금자의 주소를 저장할 변수
    uint public amount; // 송금된 금액을 저장할 변수

    constructor(address _from, uint _amount) {
        from = _from; // 생성자에서 송금자의 주소를 설정
        amount = _amount; // 생성자에서 송금된 금액을 설정
    }
}

// Wallet 컨트랙트 정의
contract Wallet {
    PaymentReceived public payment; // PaymentReceived 컨트랙트 인스턴스를 저장할 변수

    // payContract 함수: Ether를 받아 PaymentReceived 컨트랙트를 생성하는 함수
    function payContract() public payable {
        payment = new PaymentReceived(msg.sender, msg.value); // 새로운 PaymentReceived 인스턴스를 생성하고 변수에 할당
    }
}

// Wallet2 컨트랙트 정의
contract Wallet2 {
    // PaymentReceivedStruct 구조체 정의
    struct PaymentReceivedStruct { 
        address from; // 송금자의 주소를 저장할 변수
        uint amount; // 송금된 금액을 저장할 변수
    }

    PaymentReceivedStruct public payment; // PaymentReceivedStruct 구조체 변수를 저장할 변수

    // payContract 함수: Ether를 받아 PaymentReceivedStruct 변수에 송금 정보를 저장하는 함수
    function payContract() public payable {
        payment.from = msg.sender; // 송금자의 주소를 설정
        payment.amount = msg.value; // 송금된 금액을 설정
    }
}
