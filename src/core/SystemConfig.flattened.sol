// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.20;

// lib/openzeppelin-contracts/contracts/utils/Context.sol

// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// src/factory/ITadleFactory.sol

interface ITadleFactory {
    /// @dev get related contract address by index
    function relatedContracts(uint8 _index) external view returns (address);

    /// @dev Emit event when proxy admin is deployed
    event ProxyAdminDeployed(address _proxyAdmin);

    /// @dev Emit event when related contract is deployed
    /// @param _index index of related contract
    /// @param _contractAddr address of related contract
    event RelatedContractDeployed(uint256 _index, address _contractAddr);

    /// @dev Error when caller is not guardian
    error CallerIsNotGuardian(address _guardian, address _msgSender);

    /// @dev Error when proxy admin is not deployed
    error UnDepoloyedProxyAdmin();

    /// @dev Error when logic address is not a contract
    error LogicAddrIsNotContract(address _logic);
}

// src/interfaces/ISystemConfig.sol

/**
 * @title ISystemConfig
 * @dev Interface of system config
 * @notice Add new system config here
 */
interface ISystemConfig {
    /// @dev Get base platform fee rate.
    function getBaseReferralRate() external view returns (uint256);

    /**
     * @dev Get base platform fee rate.
     * @param _user address of user, create order by this user.
     */
    function getPlatformFeeRate(address _user) external view returns (uint256);

    /// @dev Get referral info by referrer
    function getReferralInfo(
        address _referrer
    ) external view returns (ReferralInfo calldata);

    /// @dev Get marketPlace info by marketPlace
    function getMarketPlaceInfo(
        address _marketPlace
    ) external view returns (MarketPlaceInfo calldata);

    /// @dev Emit events when base platform fee rate is updated
    event UpdateBasePlatformFeeRate(uint256 basePlatformFeeRate);

    /// @dev Emit events when base referral rate is updated
    event UpdateBaseReferralRate(uint256 baseReferralRate);

    /// @dev Emit events when user platform fee rate is updated
    event UpdateUserPlatformFeeRate(
        address indexed userAddress,
        uint256 userPlatformFeeRate
    );

    /// @dev Emit events when user referral extra rate is updated
    event UpdateReferralExtraRate(
        address indexed referrerAddress,
        uint256 referrerRate
    );

    /// @dev Emit events when user referral extra rate is updated
    event UpdateReferrerExtraRate(
        address indexed authorityAddress,
        uint256 authorityRate
    );

    /// @dev Emit events when create marketPlace info
    event CreateMarketPlaceInfo(
        string indexed marketPlaceName,
        address indexed marketPlaceAddress,
        bool indexed fixedratio
    );

    /// @dev Emit events when update marketPlace info
    event UpdateMarket(
        string indexed marketPlaceName,
        address indexed marketPlaceAddress,
        address indexed tokenAddress,
        uint256 tokenPerPoint,
        uint256 tge,
        uint256 settlementPeriod
    );

    /// @dev Emit events when update referrer info
    event UpdateReferrerInfo(
        address indexed authorityAddress,
        address indexed referrerAddress,
        uint256 referrerRate,
        uint256 authorityRate
    );

    /// @dev Emit events when update referrer extra rate
    event UpdateReferralExtraRateMap(
        address indexed referrerAddress,
        uint256 referrerRate
    );

    /// Error when the referrer and the referee cannot be the same person
    error InvalidReferrer(address referrer);

    /// Error when invalid referrer rate or authority rate
    error InvalidRate(
        uint256 referrerRate,
        uint256 authorityRate,
        uint256 totalRate
    );

    /// Error when referrer rate must be greater than the base number
    error InvalidReferrerRate(uint256 referrerRate);

    /// Error when invalid total rate
    error InvalidTotalRate(uint256 totalRate);

    /// Error when invalid platform fee rate
    error InvalidPlatformFeeRate(uint256 platformFeeRate);

    /// Error when marketPlace already initialized
    error MarketPlaceAlreadyInitialized();

    /// Error when marketPlace is not online
    error MarketPlaceNotOnline(MarketPlaceStatus status);
}

/**
 * @title MarketPlaceStatus
 * @dev Enum of MarketPlaceStatus
 * @notice UnInitialized, Online, AskSettling, BidSettling, Offline
 * @param UnInitialized is the default value, when marketPlace is not created.
 * @param Online is the value when marketPlace is created and online.
 * @param AskSettling is the value when ask offer or ask order is settled.
 * @param BidSettling is the value when bid offer or bid order is settled.
 * @param Offline is the value when marketPlace is offline.
 */
enum MarketPlaceStatus {
    UnInitialized,
    Online,
    AskSettling,
    BidSettling,
    Offline
}

/**
 * @title MarketPlaceInfo
 * @dev Struct of MarketPlaceInfo
 * @notice fixedratio, status, tokenAddress, tokenPerPoint, tge, settlementPeriod
 * @param fixedratio maketPlace is fixedratio type or not
 * @param status marketPlace status, detail see MarketPlaceStatus
 * @param tokenAddress the point token address
 * @param tokenPerPoint token per point
 * @param tge Token Generation Even
 * @param settlementPeriod settlement period
 */
struct MarketPlaceInfo {
    bool fixedratio;
    MarketPlaceStatus status;
    address tokenAddress;
    uint256 tokenPerPoint;
    uint256 tge;
    uint256 settlementPeriod;
}

/**
 * @title ReferralInfo
 * @dev Struct of ReferralInfo
 * @notice referrer, referrerRate, authorityRate
 * @param referrer referrer address
 * @param referrerRate referrer rate
 * @param authorityRate authority rate
 */
struct ReferralInfo {
    address referrer;
    uint256 referrerRate;
    uint256 authorityRate;
}

// src/libraries/Constants.sol

/**
 * @title Constants
 * @dev Library of constants
 * @notice Add new constants here
 */
library Constants {
    /// @dev Platform fee decimal scaler
    uint256 internal constant PLATFORM_FEE_DECIMAL_SCALER = 1_000_000;

    /// @dev Each trade tax decimal scaler
    uint256 internal constant EACH_TRADE_TAX_DECIMAL_SCALER = 10_000;

    /// @dev Collateral rate decimal scaler
    uint256 internal constant COLLATERAL_RATE_DECIMAL_SCALER = 10_000;

    /// @dev Each trade tax maxinum
    uint256 internal constant EACH_TRADE_TAX_MAXINUM = 2000;

    /// @dev Referral rate decimal scaler
    uint256 internal constant REFERRAL_RATE_DECIMAL_SCALER = 1_000_000;

    /// @dev Referral base rate
    uint256 internal constant REFERRAL_BASE_RATE = 300_000;
}

// src/libraries/GenerateAddress.sol

/**
 * @title GenerateAddress
 * @dev Library of generate address
 * @dev Generate address for maker, offer, stock and market place
 */
library GenerateAddress {
    /// @dev Generate address for maker address with id
    function generateMakerAddress(uint256 _id) internal pure returns (address) {
        return address(uint160(uint256(keccak256(abi.encode(_id, "maker")))));
    }

    /// @dev Generate address for offer address with id
    function generateOfferAddress(uint256 _id) internal pure returns (address) {
        return address(uint160(uint256(keccak256(abi.encode(_id, "offer")))));
    }

    /// @dev Generate address for stock address with id
    function generateStockAddress(uint256 _id) internal pure returns (address) {
        return address(uint160(uint256(keccak256(abi.encode(_id, "stock")))));
    }

    /// @dev Generate address for market place address with name
    function generateMarketPlaceAddress(
        string memory _marketPlaceName
    ) internal pure returns (address) {
        return
            address(uint160(uint256(keccak256(abi.encode(_marketPlaceName)))));
    }
}

// src/utils/Errors.sol

/**
 * @title Errors
 * @dev Library of errors
 * @notice Add new errors here
 */
library Errors {
    /// @dev Error when contract is not deployed
    error ContractIsNotDeployed();

    /**
     * @dev Error when not enough msg value
     * @param _msgValue msg value
     * @param _amount transfer amount
     */
    error NotEnoughMsgValue(uint256 _msgValue, uint256 _amount);

    /// @dev Error when zero address
    error ZeroAddress();

    /// @dev Error when amount is zero
    error AmountIsZero();

    /// @dev Error when unauthorized
    error Unauthorized();
}

// lib/openzeppelin-contracts/contracts/access/Ownable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// lib/openzeppelin-contracts/contracts/utils/Pausable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (utils/Pausable.sol)

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
    bool private _paused;

    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    /**
     * @dev The operation failed because the contract is paused.
     */
    error EnforcedPause();

    /**
     * @dev The operation failed because the contract is not paused.
     */
    error ExpectedPause();

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor() {
        _paused = false;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        _requirePaused();
        _;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Throws if the contract is paused.
     */
    function _requireNotPaused() internal view virtual {
        if (paused()) {
            revert EnforcedPause();
        }
    }

    /**
     * @dev Throws if the contract is not paused.
     */
    function _requirePaused() internal view virtual {
        if (!paused()) {
            revert ExpectedPause();
        }
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// src/storage/UpgradeableStorage.sol

/**
 * @title UpgradeableStorage
 * @notice This contrct serves as the storage of SystemConfig, PreMarkets, DeliveryPlace, CapitalPool and TradingHall.
 * @notice the first storage slot is used as tadle factory.
 * @notice Total Storage Gaps: 50, UnUsed Storage Slots: 49.
 */
contract UpgradeableStorage {
    /// @dev storage slot is 0
    ITadleFactory public tadleFactory;

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[49] private __gap;
}

// src/storage/SystemConfigStorage.sol

/**
 * @title SystemConfigStorage
 * @dev Storage of SystemConfig
 * @notice The top 50 storage slots are used for upgradeable storage.
 * @notice The 50th to 150th storage slots are used for SystemConfig.
 * @notice Total Storage Gaps: 100, UnUsed Storage Slots: 94.
 */

contract SystemConfigStorage is UpgradeableStorage {
    /// @dev base platform fee rate, default 0.05%
    uint256 public basePlatformFeeRate;

    /// @dev base referral rate, default 30% of platform fee
    uint256 public baseReferralRate;

    /// @dev user platform fee rate
    mapping(address => uint256) public userPlatformFeeRate;

    /// @dev user referral extra rate
    /// @notice baseReferralRate + extraReferralRate = referrerRate + authorReferralRate
    /// @dev referrerRate is the reward given to referrer
    /// @dev authorReferralRate is the reward given to trader
    mapping(address => uint256) public referralExtraRateMap;

    /// @dev user refferral info, detail see ReferralInfo.
    mapping(address => ReferralInfo) public referralInfoMap;

    /// @dev marketPlace info, detail see MarketPlaceInfo.
    mapping(address => MarketPlaceInfo) public marketPlaceInfoMap;

    /// @dev empty reserved space is put in place to allow future versions to add new
    /// variables without shifting down storage in the inheritance chain.
    /// See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
    /// start from slot 56, end at slot 149
    uint256[94] private __gap;
}

// src/utils/Rescuable.sol

/**
 * @title Rescuable
 * @dev An abstract contract that can be paused and unpaused.
 * @dev An abstract contract that can be rescued.
 */
contract Rescuable is Ownable, Pausable {
    bytes4 private constant TRANSFER_SELECTOR =
        bytes4(keccak256(bytes("transfer(address,uint256)")));
    bytes4 private constant TRANSFER_FROM_SELECTOR =
        bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));

    /// @dev Event emitted when the pause status is set
    event SetPauseStatus(bool status);

    /// @dev Event emitted when an account is rescued
    event Rescue(address to, address token, uint256 amount);

    /// @dev Error message when the transfer fails
    error TransferFailed();

    /// @dev Error message when the initialization fails
    error AlreadyInitialized();

    /// @notice Initializes the smart contract with the new implementation.
    constructor() Ownable(_msgSender()) {}

    function initializeOwnership(address _newOwner) external {
        if (owner() != address(0x0)) {
            revert AlreadyInitialized();
        }

        _transferOwnership(_newOwner);
    }

    /**
     * @notice The caller must be the owner.
     * @dev Sets the pause status.
     * @param pauseSatus The new pause status.
     */
    function setPauseStatus(bool pauseSatus) external onlyOwner {
        if (pauseSatus) {
            _pause();
        } else {
            _unpause();
        }

        emit SetPauseStatus(pauseSatus);
    }

    /**
     * @notice The caller must be the owner.
     * @dev Rescues an account.
     * @param to The address of the account to rescue.
     * @param token The token to rescue. If 0, it is ether.
     * @param amount The amount to rescue.
     * @notice The caller must be the owner.
     */
    function rescue(
        address to,
        address token,
        uint256 amount
    ) external onlyOwner {
        if (token == address(0x0)) {
            payable(to).transfer(amount);
        } else {
            _safe_transfer(token, to, amount);
        }

        emit Rescue(to, token, amount);
    }

    /**
     * @dev Safe transfer.
     * @param token The token to transfer. If 0, it is ether.
     * @param to The address of the account to transfer to.
     * @param amount The amount to transfer.
     */
    function _safe_transfer(
        address token,
        address to,
        uint256 amount
    ) internal {
        (bool success, ) = token.call(
            abi.encodeWithSelector(TRANSFER_SELECTOR, to, amount)
        );

        if (!success) {
            revert TransferFailed();
        }
    }

    /**
     * @dev Safe transfer.
     * @param token The token to transfer. If 0, it is ether.
     * @param to The address of the account to transfer to.
     * @param amount The amount to transfer.
     */
    function _safe_transfer_from(
        address token,
        address from,
        address to,
        uint256 amount
    ) internal {
        (bool success, ) = token.call(
            abi.encodeWithSelector(TRANSFER_FROM_SELECTOR, from, to, amount)
        );

        if (!success) {
            revert TransferFailed();
        }
    }
}

// src/core/SystemConfig.sol

/**
 * @title SystemConfig
 * @dev Contract of SystemConfig.
 * @dev Contains markets setting, referral setting, etc.
 */
contract SystemConfig is SystemConfigStorage, Rescuable, ISystemConfig {
    constructor() Rescuable() {}

    /**
     * @notice Set base platform fee rate and base referral rate
     * @dev Caller must be owner
     * @param _basePlatformFeeRate Base platform fee rate, default is 0.5%
     * @param _baseReferralRate Base referral rate, default is 30%
     */
    function initialize(
        uint256 _basePlatformFeeRate,
        uint256 _baseReferralRate
    ) external onlyOwner {
        basePlatformFeeRate = _basePlatformFeeRate;
        baseReferralRate = _baseReferralRate;
    }

    /**
     * @notice Update referrer setting
     * @param _referrer Referrer address
     * @param _referrerRate Referrer rate
     * @param _authorityRate Authority rate
     * @notice _referrerRate + _authorityRate = baseReferralRate + referralExtraRate
     * @notice _referrer != _msgSender()
     */
    function updateReferrerInfo(
        address _referrer,
        uint256 _referrerRate,
        uint256 _authorityRate
    ) external {
        if (_msgSender() == _referrer) {
            revert InvalidReferrer(_referrer);
        }

        if (_referrer == address(0x0)) {
            revert Errors.ZeroAddress();
        }

        if (_referrerRate < baseReferralRate) {
            revert InvalidReferrerRate(_referrerRate);
        }

        uint256 referralExtraRate = referralExtraRateMap[_referrer];
        uint256 totalRate = baseReferralRate + referralExtraRate;

        if (totalRate > Constants.REFERRAL_RATE_DECIMAL_SCALER) {
            revert InvalidTotalRate(totalRate);
        }

        if (_referrerRate + _authorityRate != totalRate) {
            revert InvalidRate(_referrerRate, _authorityRate, totalRate);
        }

        ReferralInfo storage referralInfo = referralInfoMap[_referrer];
        referralInfo.referrer = _referrer;
        referralInfo.referrerRate = _referrerRate;
        referralInfo.authorityRate = _authorityRate;

        emit UpdateReferrerInfo(
            msg.sender,
            _referrer,
            _referrerRate,
            _authorityRate
        );
    }

    /**
     * @notice Create market place
     * @param _marketPlaceName Market place name
     * @param _fixedratio Fixed ratio
     * @notice Caller must be owner
     * @notice _marketPlaceName must be unique
     * @notice _fixedratio is true if the market place is arbitration required
     */
    function createMarketPlace(
        string calldata _marketPlaceName,
        bool _fixedratio
    ) external onlyOwner {
        address marketPlace = GenerateAddress.generateMarketPlaceAddress(
            _marketPlaceName
        );
        MarketPlaceInfo storage marketPlaceInfo = marketPlaceInfoMap[
            marketPlace
        ];

        if (marketPlaceInfo.status != MarketPlaceStatus.UnInitialized) {
            revert MarketPlaceAlreadyInitialized();
        }

        marketPlaceInfo.status = MarketPlaceStatus.Online;
        marketPlaceInfo.fixedratio = _fixedratio;

        emit CreateMarketPlaceInfo(_marketPlaceName, marketPlace, _fixedratio);
    }

    /**
     * @notice Update market when settlement time is passed
     * @param _marketPlaceName Market place name
     * @param _tokenAddress Token address
     * @param _tokenPerPoint Token per point
     * @param _tge TGE
     * @param _settlementPeriod Settlement period
     * @notice Caller must be owner
     */
    function updateMarket(
        string calldata _marketPlaceName,
        address _tokenAddress,
        uint256 _tokenPerPoint,
        uint256 _tge,
        uint256 _settlementPeriod
    ) external onlyOwner {
        address marketPlace = GenerateAddress.generateMarketPlaceAddress(
            _marketPlaceName
        );

        MarketPlaceInfo storage marketPlaceInfo = marketPlaceInfoMap[
            marketPlace
        ];

        if (marketPlaceInfo.status != MarketPlaceStatus.Online) {
            revert MarketPlaceNotOnline(marketPlaceInfo.status);
        }

        marketPlaceInfo.tokenAddress = _tokenAddress;
        marketPlaceInfo.tokenPerPoint = _tokenPerPoint;
        marketPlaceInfo.tge = _tge;
        marketPlaceInfo.settlementPeriod = _settlementPeriod;

        emit UpdateMarket(
            _marketPlaceName,
            marketPlace,
            _tokenAddress,
            _tokenPerPoint,
            _tge,
            _settlementPeriod
        );
    }

    /**
     * @notice Update market place status
     * @param _marketPlaceName Market place name
     * @param _status Market place status
     * @notice Caller must be owner
     */
    function updateMarketPlaceStatus(
        string calldata _marketPlaceName,
        MarketPlaceStatus _status
    ) external onlyOwner {
        address marketPlace = GenerateAddress.generateMarketPlaceAddress(
            _marketPlaceName
        );
        MarketPlaceInfo storage marketPlaceInfo = marketPlaceInfoMap[
            marketPlace
        ];
        marketPlaceInfo.status = _status;
    }

    /**
     * @notice Update base platform fee rate
     * @param _accountAddress Account address
     * @param _platformFeeRate Platform fee rate of user
     * @notice Caller must be owner
     */
    function updateUserPlatformFeeRate(
        address _accountAddress,
        uint256 _platformFeeRate
    ) external onlyOwner {
        require(
            _platformFeeRate <= Constants.PLATFORM_FEE_DECIMAL_SCALER,
            "Invalid platform fee rate"
        );
        userPlatformFeeRate[_accountAddress] = _platformFeeRate;

        emit UpdateUserPlatformFeeRate(_accountAddress, _platformFeeRate);
    }

    /**
     * @notice Update referrer extra rate
     * @param _referrer Referrer address
     * @param _extraRate Extra rate
     * @notice Caller must be owner
     * @notice _extraRate + baseReferralRate <= REFERRAL_RATE_DECIMAL_SCALER
     */
    function updateReferralExtraRateMap(
        address _referrer,
        uint256 _extraRate
    ) external onlyOwner {
        uint256 totalRate = _extraRate + baseReferralRate;
        if (totalRate > Constants.REFERRAL_RATE_DECIMAL_SCALER) {
            revert InvalidTotalRate(totalRate);
        }
        referralExtraRateMap[_referrer] = _extraRate;
        emit UpdateReferralExtraRateMap(_referrer, _extraRate);
    }

    /// @dev Get base platform fee rate.
    function getBaseReferralRate() external view returns (uint256) {
        return baseReferralRate;
    }

    /**
     * @dev Get base platform fee rate.
     * @param _user address of user, create order by this user.
     */
    function getPlatformFeeRate(address _user) external view returns (uint256) {
        if (userPlatformFeeRate[_user] == 0) {
            return basePlatformFeeRate;
        }

        return userPlatformFeeRate[_user];
    }

    /// @dev Get referral info by referrer
    function getReferralInfo(
        address _referrer
    ) external view returns (ReferralInfo memory) {
        return referralInfoMap[_referrer];
    }

    /// @dev Get marketPlace info by marketPlace
    function getMarketPlaceInfo(
        address _marketPlace
    ) external view returns (MarketPlaceInfo memory) {
        return marketPlaceInfoMap[_marketPlace];
    }
}
