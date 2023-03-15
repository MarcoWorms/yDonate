pragma solidity ^0.8.14;
pragma experimental ABIEncoderV2;

interface IyRegistry {
  function setGovernance ( address governance ) external;
  function acceptGovernance (  ) external;
  function latestRelease (  ) external view returns ( string memory );
  function latestVault ( address token ) external view returns ( address );
  function newRelease ( address vault ) external;
  function newVault ( address token, address guardian, address rewards, string memory name, string memory symbol ) external returns ( address );
  function newVault ( address token, address guardian, address rewards, string memory name, string memory symbol, uint256 releaseDelta ) external returns ( address );
  function newExperimentalVault ( address token, address governance, address guardian, address rewards, string memory name, string memory symbol ) external returns ( address );
  function newExperimentalVault ( address token, address governance, address guardian, address rewards, string memory name, string memory symbol, uint256 releaseDelta ) external returns ( address );
  function endorseVault ( address vault ) external;
  function endorseVault ( address vault, uint256 releaseDelta ) external;
  function setBanksy ( address tagger ) external;
  function setBanksy ( address tagger, bool allowed ) external;
  function tagVault ( address vault, string memory tag ) external;
  function numReleases (  ) external view returns ( uint256 );
  function releases ( uint256 arg0 ) external view returns ( address );
  function numVaults ( address arg0 ) external view returns ( uint256 );
  function vaults ( address arg0, uint256 arg1 ) external view returns ( address );
  function tokens ( uint256 arg0 ) external view returns ( address );
  function numTokens (  ) external view returns ( uint256 );
  function isRegistered ( address arg0 ) external view returns ( bool );
  function governance (  ) external view returns ( address );
  function pendingGovernance (  ) external view returns ( address );
  function tags ( address arg0 ) external view returns ( string memory );
  function banksy ( address arg0 ) external view returns ( bool );
}
