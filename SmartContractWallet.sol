// SPDX-License-Identifier: MIT
// pragma solidity 0.8.15;

contract SampleWallet {
    address payable owner; // 스마트 지갑의 소유자 주소

    // 각 주소의 할당된 금액 및 송금 권한 여부를 저장하는 매핑
    mapping(address => uint) public allowance;
    mapping(address => bool) public isAllowedToSend;

    // 보호자 및 다음 소유자 관련 변수
    mapping(address => bool) public guardian;
    address payable nextOwner;
    uint guardiansResetCount;
    uint public constant confirmationsFromGuardiansForReset = 3;

    // 생성자: 스마트 지갑 소유자를 설정합니다.
    constructor() {
        owner = payable(msg.sender);
    }

    // 새로운 소유자를 제안하는 함수
    function proposeNewOwner(address payable newOwner) public {
        // 현재 호출한 주소가 보호자인지 확인하고 아니면 중단합니다.
        require(guardian[msg.sender], "You are not a guardian, aborting");

        // 새로운 소유자 주소(newOwner)가 현재 저장된 주소(nextOwner)와 다르면
        // 새로운 소유자 주소를 업데이트하고 보호자 재설정 카운트를 0으로 초기화합니다.
        if (nextOwner != newOwner) {
            nextOwner = newOwner;
            guardiansResetCount = 0;
        }

        // 보호자 재설정 카운트를 증가시킵니다.
        guardiansResetCount++;

        // 보호자 재설정 카운트가 설정된 임계값(confirmationsFromGuardiansForReset) 이상인 경우,
        // 현재 소유자 주소(owner)를 새로운 소유자 주소(nextOwner)로 변경하고 nextOwner를 초기화합니다.
        if (guardiansResetCount >= confirmationsFromGuardiansForReset) {
            owner = nextOwner;
            nextOwner = payable(address(0));
        }
    }

    // 특정 주소에 대한 할당량 설정 함수
    function setAllowance(address _from, uint _amount) public {
        // 호출한 주소가 소유자인지 확인하고 아니면 중단합니다.
        require(msg.sender == owner, "You are not the owner, aborting!");

        // 주어진 주소(_from)에 할당된 금액(_amount)을 설정하고 해당 주소의 송금 권한을 활성화합니다.
        allowance[_from] = _amount;
        isAllowedToSend[_from] = true;
    }

    // 특정 주소의 송금 권한 취소 함수
    function denySending(address _from) public {
        // 호출한 주소가 소유자인지 확인하고 아니면 중단합니다.
        require(msg.sender == owner, "You are not the owner, aborting!");

        // 주어진 주소(_from)의 송금 권한을 비활성화합니다.
        isAllowedToSend[_from] = false;
    }

    // 금액과 데이터(payload)을 포함하여 특정 주소로 Ether를 전송하는 함수
    function transfer(address payable _to, uint _amount, bytes memory payload) public returns (bytes memory) {
        // 전송하려는 금액(_amount)이 계약의 잔액을 초과하는지 확인하고 초과하면 중단합니다.
        require(_amount <= address(this).balance, "Can't send more than the contract owns, aborting.");
        
        if (msg.sender != owner) {
            // 호출한 주소가 소유자가 아닌 경우
            // 해당 주소가 송금 권한을 가지고 있는지 확인하고, 송금 권한이 없으면 중단합니다.
            require(isAllowedToSend[msg.sender], "You are not allowed to send any transactions, aborting");

            // 호출한 주소가 송금 권한이 있는 경우
            // 보낼 금액(_amount)이 할당량(allowance)을 초과하지 않는지 확인하고 초과하면 중단합니다.
            require(allowance[msg.sender] >= _amount, "You are trying to send more than you are allowed to, aborting");

            // 할당량에서 보낼 금액(_amount)을 차감합니다.
            allowance[msg.sender] -= _amount;
        }

        // 특정 주소(_to)로 Ether를 전송하고 전송 결과(success)를 확인합니다.
        (bool success, bytes memory returnData) = _to.call{value: _amount}(payload);
        require(success, "Transaction failed, aborting");

        // 전송 결과를 반환합니다.
        return returnData;
    }

    receive() external payable {}
}