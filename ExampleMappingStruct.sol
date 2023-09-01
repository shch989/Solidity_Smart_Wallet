// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract MappingStructExample {

    // 입출금 내역을 저장하기 위한 구조체 정의
    struct Transaction {
        uint amount;      // 금액
        uint timestamp;   // 타임스탬프
    }

    // 사용자의 잔액과 입출금 내역을 관리하기 위한 구조체 정의
    struct Balance {
        uint totalBalance;                  // 총 잔액
        uint numDeposits;                   // 입금 건수
        mapping(uint => Transaction) deposits;     // 입금 내역 매핑
        uint numWithdrawals;                // 출금 건수
        mapping(uint => Transaction) withdrawals;  // 출금 내역 매핑
    }

    // 사용자 주소를 키로 하여 사용자의 잔액과 입출금 내역을 관리하는 매핑
    mapping(address => Balance) public balances;

    // 특정 입금 내역을 조회하는 함수
    function getDepositNum(address _from, uint _numDeposit) public view returns(Transaction memory) {
        return balances[_from].deposits[_numDeposit];
    }

    // Ether를 입금하는 함수
    function depositMoney() public payable {
        balances[msg.sender].totalBalance += msg.value;

        // 입금 내역 생성 및 저장
        Transaction memory deposit = Transaction(msg.value, block.timestamp);
        balances[msg.sender].deposits[balances[msg.sender].numDeposits] = deposit;
        balances[msg.sender].numDeposits++;
    }

    // Ether를 출금하는 함수
    function withdrawMoney(address payable _to, uint _amount) public {
        require(balances[msg.sender].totalBalance >= _amount, "Not enough balance"); // 출금 가능 여부 확인

        balances[msg.sender].totalBalance -= _amount;

        // 출금 내역 생성 및 저장
        Transaction memory withdrawal = Transaction(_amount, block.timestamp);
        balances[msg.sender].withdrawals[balances[msg.sender].numWithdrawals] = withdrawal;
        balances[msg.sender].numWithdrawals++;

        // 지정된 주소로 Ether 전송
        _to.transfer(_amount);
    }
}