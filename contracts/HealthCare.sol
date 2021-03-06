pragma solidity ^0.4.24;

contract HealthCare {

    address private hospitalAdmin;
    address private labAdmin;

    struct Record {
        address pAddr;
        uint256 ID;
        string testName;
        string date;
        string hospitalName;
        uint256 price;
        bool isValue;
        uint256 signatureCount;
        mapping (address => uint256) signatures;
    }

    modifier signOnly {
        require (msg.sender == hospitalAdmin || msg.sender == labAdmin );
        _;
    }

    mapping (uint256=> Record) public _records;
    uint256[] public recordsArr;

      constructor() public {

        hospitalAdmin = msg.sender;
        labAdmin = 0x7fAA47fc6F7027feF185c766f9c3C0cb5d8D8850;                       //enter address
    }

    event recordCreated(uint256 ID, string testName, string date, string hospitalName, uint256 price);
    event recordSigned(uint256 ID, string testName, string date, string hospitalName, uint256 price);

    function newRecord (uint256 _ID, string _tName, string _date, string hName, uint256 price) public{
        Record storage _newrecord = _records[_ID];

         require(!_records[_ID].isValue);

            _newrecord.pAddr = msg.sender;
            _newrecord.ID = _ID;
            _newrecord.testName = _tName;
            _newrecord.date = _date;
            _newrecord.hospitalName = hName;
            _newrecord.price = price;
            _newrecord.isValue = true;
            _newrecord.signatureCount = 0;

        recordsArr.push(_ID);
        emit  recordCreated(_newrecord.ID, _tName, _date, hName, price);
    }

   /* function getRecords(uint256 _ID) public view returns (uint256, string, string, string, uint256, uint256){
        return (_records[_ID].ID, _records[_ID].testName, _records[_ID].date, _records[_ID].hospitalName, _records[_ID].price, _records[_ID].signatureCount);
    } */

    function signRecord(uint256 _ID) signOnly public {
        Record storage records = _records[_ID];

        require(address(0) != records.pAddr);

        require(msg.sender != records.pAddr);

        require(records.signatures[msg.sender] != 1);

        records.signatures[msg.sender] = 1;
        records.signatureCount++;

        if(records.signatureCount == 2)
            emit  recordSigned(records.ID, records.testName, records.date, records.hospitalName, records.price);

    }
}
