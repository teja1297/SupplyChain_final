// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "./StorageSupplyChain.sol";

contract PharmaSupplyChain {
event addDrug(address indexed user, address indexed SerialNumber);
event MovedFromManufacturer(address indexed user, address indexed SerialNumber);
event MovedFromDistributor(address indexed user, address indexed SerialNumber);
event MovedFromWholesaler(address indexed user, address indexed SerialNumber);
event MovedToPharmacy(address indexed user, address indexed SerialNumber);

modifier isValidPerformer(address _SerialNumber, string memory role) {
        require(keccak256(abi.encodePacked(supplyChainStorage.getUserRole(msg.sender))) == keccak256(abi.encodePacked(role)));
        require(keccak256(abi.encodePacked(supplyChainStorage.getnextOwner(_SerialNumber))) == keccak256(abi.encodePacked(role)));
        _;

   }



string public x   = "PharmaSupplyChain Contarct";


     /* Storage Variables */    
     SupplyChainStorage supplyChainStorage;

 constructor(address _supplyChainAddress) public {
        supplyChainStorage = SupplyChainStorage(_supplyChainAddress);
    }

    

   //gets the list of userKeys
   function getUserList() public view returns(address[] memory UserList)
   {
      return supplyChainStorage.getUserKeyList();
   }
   //gets the list of DrugKeys
   function getDrugList() public view returns(address[] memory DrugKeyList){
      return supplyChainStorage.getDrugKeyList();
   }

   
    function getnextOwner(address _SerialNumber) public view returns(string memory Owner)
    {
       (Owner) = supplyChainStorage.getnextOwner(_SerialNumber);
       return (Owner);
    }


      function getUserRole(address _userAddress)public view returns(string memory){
         return supplyChainStorage.getUserRole(_userAddress);
      }

    function addUser(address  _userAddress,
                     string memory _ParticipantName, 
                      string  memory _contactNo, 
                        string memory _role, 
                         string memory _Username,
                         string memory _password,
                        string memory _Email,
                     bool _isActive) public returns(bool){

                       bool result = supplyChainStorage.setUser(_userAddress,_ParticipantName,_contactNo,_role,_Username,_password,_Email,_isActive);
                       
                        return result;
    }


   function addDrugDetails(uint32 _drugID,
        uint32 _batchID,
        string memory _drugName,
        string memory _Currentlocation,
       
        uint _mfgTimeStamp,
        uint _expTimeStamp,
        uint32  _CurrentTemperature,
        uint32 _IdealTemperature
     ) public  returns(address){
         address SerialNumber = supplyChainStorage.setDrugDetails(_drugID,_batchID,_drugName,_Currentlocation,_mfgTimeStamp,_expTimeStamp,_CurrentTemperature,_IdealTemperature);
          emit addDrug(msg.sender, SerialNumber); 
          return SerialNumber;
     }

      function MoveFromManufacturer(address _SerialNumber,
                             string memory _name,
                             string memory _ManufacturerAddress,
                             address _ExporterAddress,
                             uint32  _ExportingTemparature
                            
                             )public isValidPerformer(_SerialNumber,'Manufacturer')  returns(bool){

                                bool result =  supplyChainStorage.MoveFromManufacturer(_SerialNumber,_name,_ManufacturerAddress, _ExporterAddress,_ExportingTemparature);
                                emit MovedFromManufacturer(msg.sender,_SerialNumber);
                                return result;
                             }


        function receivedToDistributor(address _SerialNumber, string memory _name,string memory _DistributorAddress,uint32 _ImportingTemparature)public  returns(bool){
               return supplyChainStorage.distributorReceving(_SerialNumber,_name,_DistributorAddress,_ImportingTemparature);
        }


function MoveFromDistributor(address _SerialNumber,
        uint32 _ExportingTemparature,
       address _ExporterAddress
        ) public isValidPerformer(_SerialNumber,'Distributor') returns(bool){

             bool result =  supplyChainStorage.MoveFromDistributor(_SerialNumber, _ExportingTemparature,_ExporterAddress);
                                emit MovedFromDistributor(msg.sender,_SerialNumber);
                                return result;   
            }



        function receivedToWholeSaler(address _SerialNumber, string memory _name,string memory _WholesalerAddress,uint32 _ImportingTemparature)public  returns(bool){
               return supplyChainStorage.WholeSalerReceving(_SerialNumber,_name,_WholesalerAddress,_ImportingTemparature);
        }


function MoveFromWholesaler(address _SerialNumber,
        uint32 _ExportingTemparature,
        address _ExporterAddress
        ) public isValidPerformer(_SerialNumber,'Wholesaler') returns(bool){

             bool result =  supplyChainStorage.moveFromWholesaler(_SerialNumber, _ExportingTemparature,_ExporterAddress);
                                emit MovedFromWholesaler(msg.sender,_SerialNumber);
                                return result;   
            }



function importToPharmacy(address _SerialNumber,
        string memory _PharmacyName,
        string memory _PharmacyAddress,
        uint32 _ImportingTemparature) public isValidPerformer(_SerialNumber,'Pharmacy') returns(bool){
            bool result = supplyChainStorage.importToPharmacy(_SerialNumber,_PharmacyName,_PharmacyAddress,_ImportingTemparature);
            emit MovedToPharmacy(msg.sender,_SerialNumber);
            return result;
        }

        function Authenticate(string memory _username, string memory _password,address _userAddress)public view returns(bool){
         return supplyChainStorage.Authenticate(_username,_password,_userAddress);
        }




        function UserDetails(address _userAddress)public view returns(string memory ParticipantName,
        string memory contactNo,
        bool isActive,
        string memory UserName,
        string memory password,
        string memory Email){
           return supplyChainStorage.BatchUserDetails(_userAddress);
        }
      


        function ManufacturerDetails(address _SerialNumber)public view returns(string memory name,
        string memory ManufacturerAddress,
        address ExporterAddress,
        uint32 ExportingTemparature,
        uint256 ExportingDateTime,
        string memory DrugStatus){
     return supplyChainStorage.BatchManufactureringDetails(_SerialNumber);
        }

        function DistributorDetails(address _SerialNumber) public view returns( string memory name,
        string memory DistributorAddress,
        uint32 ImportingTemparature,
        uint32 ExportingTemparature,
        uint256 ImportingDateTime,
        uint256 ExportingDateTime,
        address ExporterAddress,
        string memory DrugStatus){
           return supplyChainStorage.BatchdistributorDetails(_SerialNumber);
        }

        function WholesalerDetails(address _SerialNumber) public view returns(string memory name,
        string memory WholesalerAddress,
        uint32 ImportingTemparature,
        uint32 ExportingTemparature,
        uint256 ImportingDateTime,
        uint256 ExportingDateTime,
       address ExporterAddress,
        string memory DrugStatus){
           return supplyChainStorage.BatchWholesalerDetails(_SerialNumber);
        }

         function PharmacyDetails(address _SerialNumber) public view returns( string memory PharmacyName,
        string memory PharmacyAddress,
        uint32 ImportingTemparature,
        string memory DrugStatus,
        uint256 ImportingDateTime){
           return supplyChainStorage.BatchPharmacyDetails(_SerialNumber);
        }
         

         function getDrugDetails1(address _SerialNumber) public  view returns(uint32 _drugID,
        uint32 _batchID,
        string memory _drugName,
        string memory _Currentlocation,
        string memory _status,
        bool _isBad
        ){
      
      return supplyChainStorage.getDrugDetails1(_SerialNumber);

      }

 function getDrugDetails2(address _SerialNumber) public  view returns(address _CurrentproductOwner,
        uint _mfgTimeStamp,
        uint _expTimeStamp,
        uint32  _CurrentTemperature,
        uint32 _IdealTemperature,
        address _nextOwner
        ){
      
      return supplyChainStorage.getDrugDetails2(_SerialNumber);

      }



        function test() public view returns(string memory){
           return x;
        }

}
