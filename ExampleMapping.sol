// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// 스마트 컨트랙트 선언
contract ExampleMapping {
    // uint(부호 없는 정수)를 불리언 값에 매핑하는 매핑 변수
    mapping(uint => bool) public myMapping;
    
    // 주소를 불리언 값에 매핑하는 매핑 변수
    mapping(address => bool) public myAddressMapping;
    
    // 두 개의 uint 키로 인덱싱된 불리언 값을 매핑하는 매핑 변수
    mapping(uint => mapping(uint => bool)) public uintUintBoolMapping;

    // myMapping 매핑 변수에 값을 설정하는 함수
    function setValue(uint _index) public {
        myMapping[_index] = true;
    }

    // 호출자의 주소를 myAddressMapping 매핑 변수에 true로 설정하는 함수
    function setMyAddressToTrue() public {
        myAddressMapping[msg.sender] = true;
    }

    // 두 개의 uint 키를 사용하여 uintUintBoolMapping 매핑 변수에 값을 설정하는 함수
    function setUintUintBoolMapping(uint _key1, uint _key2, bool _value) public {
        uintUintBoolMapping[_key1][_key2] = _value;
    }
}