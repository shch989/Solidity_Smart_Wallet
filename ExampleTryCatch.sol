// SPDX-License-Identifier: MIT
// pragma solidity 0.8.15;

// WillThrow 컨트랙트 정의
contract WillThrow {
    // 사용자 정의 에러 선언
    error NotAllowedError(string);

    // 예외를 발생시키는 함수
    function aFunction() public pure {
        // 아래의 주석 처리된 코드 대신에 'revert'를 사용하여 사용자 정의 에러를 발생시킵니다.
        // require(false, "Error message");
        // assert(false);
        revert NotAllowedError("You are not allowed"); // NotAllowedError 에러를 발생시킵니다.
    }
}

// ErrorHandling 컨트랙트 정의
contract ErrorHandling {
    // 에러를 로깅하는 이벤트 선언
    event ErrorLogging(string reason);
    event ErrorLogCode(uint code);
    event ErrorLogBytes(bytes lowLevelData);

    // 예외를 처리하고 에러를 로깅하는 함수
    function catchTheError() public {
        // WillThrow 컨트랙트의 인스턴스 생성
        WillThrow will = new WillThrow();

        try will.aFunction() { // WillThrow 컨트랙트의 aFunction()을 호출하고 예외를 기다립니다.

        } catch Error(string memory reason) { // 사용자 정의 에러를 처리합니다.
            emit ErrorLogging(reason); // 로깅 이벤트를 트리거하여 에러 메시지를 기록합니다.
        } catch Panic(uint errorCode) { // Panic 에러를 처리합니다.
            emit ErrorLogCode(errorCode); // 로깅 이벤트를 트리거하여 에러 코드를 기록합니다.
        } catch(bytes memory lowLevelData) { // 낮은 수준의 바이트 데이터를 처리합니다.
            emit ErrorLogBytes(lowLevelData); // 로깅 이벤트를 트리거하여 낮은 수준의 데이터를 기록합니다.
        }
    }
}