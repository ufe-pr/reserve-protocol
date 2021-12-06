// SPDX-License-Identifier: BlueOak-1.0.0
pragma solidity 0.8.9;

import "contracts/test/Mixins.sol";
import "contracts/p0/interfaces/IStRSR.sol";
import "contracts/p0/StRSR.sol";

/// Enables generic testing harness to set _msgSender() for StRSR.
contract StRSRExtension is ContextMixin, StRSRP0, IExtension {
    constructor(
        address admin,
        IMain main_,
        string memory name_,
        string memory symbol_
    ) ContextMixin(admin) StRSRP0(main_, name_, symbol_) {}

    function assertInvariants() external view override {
        assert(true);
    }

    function _msgSender() internal view override returns (address) {
        return _mixinMsgSender();
    }
}
