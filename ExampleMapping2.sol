// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// 자금 입금 및 인출을 다루는 스마트 컨트랙트
contract ExampleMappingWithdrawals {

    // 사용자 주소와 해당 주소에 대한 입금 잔액을 매핑하는 매핑 변수
    mapping(address => uint) public balanceReceived;
    
    // Ether를 스마트 컨트랙트로 송금하는 함수
    function sendMoney() public payable {
        // 메시지에 포함된 Ether 값을 사용자의 잔액에 추가
        balanceReceived[msg.sender] += msg.value;
    }

    // 스마트 컨트랙트의 잔액을 조회하는 함수
    function getBalance() public view returns(uint) {
        // 현재 스마트 컨트랙트의 잔액을 반환
        return address(this).balance;
    }

    // 사용자가 모든 자금을 인출하는 함수
    function withdrawAllMoney(address payable _to) public {
        // 사용자의 잔액을 별도로 저장
        uint balanceToSendOut = balanceReceived[msg.sender];
        // 사용자의 잔액을 0으로 초기화
        balanceReceived[msg.sender] = 0;
        // 저장된 잔액을 사용자의 주소로 전송
        _to.transfer(balanceToSendOut);
    }
}