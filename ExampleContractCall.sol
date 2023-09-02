// SPDX-License-Identifier: MIT
// pragma solidity 0.8.15;

// ContractOne 컨트랙트 정의
contract ContractOne {
    
    mapping (address => uint) public addressBalances;

    // Ether를 입금하는 함수
    function deposit() public payable {
        addressBalances[msg.sender] += msg.value; // 송금자의 잔액에 Ether 추가
    }

    // receive 함수: 이 컨트랙트로 직접 Ether를 전송할 때 호출됩니다.
    receive() external payable {
        deposit(); // receive 함수가 호출되면 deposit 함수를 호출하여 Ether를 입금합니다.
    }
}

// ContractTwo 컨트랙트 정의
contract ContractTwo {
    
    // receive 함수: 이 컨트랙트로 직접 Ether를 전송할 때 호출됩니다.
    receive() external payable {}

    // 다른 컨트랙트 (ContractOne) 에서 Ether를 입금하는 함수
    function depositOnContractOne(address _contractOne) public {
        // 다른 컨트랙트의 "deposit" 함수를 호출하여 Ether를 전송합니다.
        // bytes memory payload = abi.encodeWithSignature("deposit()");
        (bool success, ) = _contractOne.call{value: 10, gas: 100000}("");
        require(success); // 호출이 성공했는지 확인하고, 실패 시 예외를 발생시킵니다.
    }
}