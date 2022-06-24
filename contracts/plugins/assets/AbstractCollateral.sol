// SPDX-License-Identifier: BlueOak-1.0.0
pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "contracts/interfaces/IAsset.sol";
import "./Asset.sol";
import "./OracleLib.sol";

/**
 * @title Collateral
 * @notice Parent class for all collateral
 */
abstract contract Collateral is ICollateral, Asset {
    using OracleLib for AggregatorV3Interface;

    // targetName: The canonical name of this collateral's target unit.
    bytes32 public immutable targetName;

    constructor(
        AggregatorV3Interface chainlinkFeed_,
        IERC20Metadata erc20_,
        uint192 maxTradeVolume_,
        bytes32 targetName_
    ) Asset(chainlinkFeed_, erc20_, maxTradeVolume_) {
        targetName = targetName_;
    }

    /// @return {UoA/tok} Our best guess at the market price of 1 whole token in UoA
    function price() public view virtual override(Asset, IAsset) returns (uint192) {
        return chainlinkFeed.price();
    }

    // solhint-disable-next-line no-empty-blocks
    function refresh() external virtual {}

    /// @return The collateral's status -- always SOUND!
    function status() public view virtual returns (CollateralStatus) {
        return CollateralStatus.SOUND;
    }

    /// @return If the asset is an instance of ICollateral or not
    function isCollateral() external pure virtual override(Asset, IAsset) returns (bool) {
        return true;
    }

    /// @return {ref/tok} Quantity of whole reference units per whole collateral tokens
    function refPerTok() public view virtual returns (uint192) {
        return FIX_ONE;
    }

    /// @return {target/ref} Quantity of whole target units per whole reference unit in the peg
    function targetPerRef() public view virtual returns (uint192) {
        return FIX_ONE;
    }

    /// @return {UoA/target} The price of a target unit in UoA
    function pricePerTarget() public view virtual returns (uint192) {
        return FIX_ONE;
    }
}
