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

// src/interfaces/ICapitalPool.sol

/**
 * @title ICapitalPool
 * @dev Interface of CapitalPool
 */
interface ICapitalPool {
    /**
     * @dev Approve token for token manager
     * @notice only can be called by token manager
     * @param tokenAddr address of token
     */
    function approve(address tokenAddr) external;

    /// @dev Error when approve failed
    error ApproveFailed();
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

// src/interfaces/ITokenManager.sol

/**
 * @title ITokenManager
 * @dev Interface of TokenManager
 */
interface ITokenManager {
    /**
     * @dev Till in, token from user to capital pool
     * @param accountAddress user address
     * @param tokenAddress token address
     * @param amount amount of token
     * @param isPointToken is point token
     */
    function tillIn(
        address accountAddress,
        address tokenAddress,
        uint256 amount,
        bool isPointToken
    ) external payable;

    /**
     * @dev Add token balance
     * @param tokenBalanceType token balance type
     * @param accountAddress user address
     * @param tokenAddress token address
     * @param amount the claimable amount of token
     */
    function addTokenBalance(
        TokenBalanceType tokenBalanceType,
        address accountAddress,
        address tokenAddress,
        uint256 amount
    ) external;

    /// @dev Emit events when till in
    event TillIn(
        address indexed accountAddress,
        address indexed tokenAddress,
        uint256 amount,
        bool isPointToken
    );

    /// @dev Emit events when add token balance
    event AddTokenBalance(
        address indexed accountAddress,
        address indexed tokenAddress,
        TokenBalanceType indexed tokenBalanceType,
        uint256 amount
    );

    /// @dev Emit events when withdraw
    event Withdraw(
        address indexed authority,
        address indexed tokenAddress,
        TokenBalanceType indexed tokenBalanceType,
        uint256 amount
    );

    /// @dev Emit events when update token white list
    event UpdateTokenWhiteListed(
        address indexed tokenAddress,
        bool isWhiteListed
    );

    /// @dev Error when token is not whitelisted
    error TokenIsNotWhiteListed(address tokenAddress);
}

/**
 * @notice TokenBalanceType
 * @dev Token balance type
 * @param TaxIncome: tax income
 * @param ReferralBonus: referral bonus
 * @param SalesRevenue: sales revenue
 * @param RemainingCash: remaining cash
 * @param MakerRefund: maker refund
 * @param PointToken: balance of point token
 */
enum TokenBalanceType {
    TaxIncome,
    ReferralBonus,
    SalesRevenue,
    RemainingCash,
    MakerRefund,
    PointToken
}

// src/storage/OfferStatus.sol

/**
 * @dev Offer status
 * @notice Unknown, Virgin, Ongoing, Canceled, Filled, Settling, Settled
 * @param Unknown offer not yet exist.
 * @param Virgin offer has been listed, but not one trade.
 * @param Ongoing offer has been listed, and already one trade.
 * @param Canceled offer has been canceled.
 * @param Filled offer has been filled.
 * @param Settling offer is settling.
 * @param Settled offer has been settled, the last status.
 */
enum OfferStatus {
    Unknown,
    Virgin,
    Ongoing,
    Canceled,
    Filled,
    Settling,
    Settled
}

/**
 * @dev Offer type
 * @notice Ask, Bid
 * @param Ask create offer to sell points
 * @param Bid create offer to buy points
 */
enum OfferType {
    Ask,
    Bid
}

/**
 * @dev Stock type
 * @notice Ask, Bid
 * @param Ask create order to sell points
 * @param Bid create order to buy points
 */
enum StockType {
    Ask,
    Bid
}

/**
 * @dev Stock status
 * @notice Unknown, Initialized, Finished
 * @param Unknown order not yet exist.
 * @param Initialized order already exist
 * @param Finished order already finished
 */
enum StockStatus {
    Unknown,
    Initialized,
    Finished
}

/**
 * @dev Offer settle type
 * @notice Protected, Turbo
 * @param Protected offer type is protected
 * @param Turbo offer type is turbo
 */
enum OfferSettleType {
    Protected,
    Turbo
}

/**
 * @dev Abort offer status
 * @notice Initialized, SubOfferListed, Aborted
 * @param Initialized offer not yet exist.
 * @param SubOfferListed some one trade, and relist the offer
 * @param Aborted order has been aborted
 */
enum AbortOfferStatus {
    Initialized,
    SubOfferListed,
    Aborted
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

// src/interfaces/IDeliveryPlace.sol

/**
 * @title IDeliveryPlace
 * @dev Interface of DeliveryPlace
 */
interface IDeliveryPlace {
    /**
     * @dev Emit events when close bid offer
     * @param _marketPlace market place address
     * @param _maker maker address
     * @param _offer offer address
     * @param _authority authority address
     */
    event CloseBidOffer(
        address indexed _marketPlace,
        address indexed _maker,
        address indexed _offer,
        address _authority
    );

    /**
     * @dev Emit events when close bid taker
     * @param _marketPlace market place address
     * @param _maker maker address
     * @param _stock stock address
     * @param _authority authority address
     * @param _userCollateralFee user collateral fee
     * @param _pointTokenAmount point token amount
     */
    event CloseBidTaker(
        address indexed _marketPlace,
        address indexed _maker,
        address indexed _stock,
        address _authority,
        uint256 _userCollateralFee,
        uint256 _pointTokenAmount
    );

    /**
     * @dev Emit events when settle ask maker
     * @param _marketPlace market place address
     * @param _maker maker address
     * @param _offer offer address
     * @param _authority authority address
     * @param _settledPoints settled points
     * @param _settledPointTokenAmount settled point token amount
     * @param _makerRefundAmount maker refund amount
     */
    event SettleAskMaker(
        address indexed _marketPlace,
        address indexed _maker,
        address indexed _offer,
        address _authority,
        uint256 _settledPoints,
        uint256 _settledPointTokenAmount,
        uint256 _makerRefundAmount
    );

    /**
     * @dev Emit events when settle ask taker
     * @param _marketPlace market place address
     * @param _maker maker address
     * @param _stock stock address
     * @param _preOffer pre offer address
     * @param _authority authority address
     * @param _settledPoints settled points
     * @param _settledPointTokenAmount settled point token amount
     * @param _collateralFee collateral fee
     */
    event SettleAskTaker(
        address indexed _marketPlace,
        address indexed _maker,
        address indexed _stock,
        address _preOffer,
        address _authority,
        uint256 _settledPoints,
        uint256 _settledPointTokenAmount,
        uint256 _collateralFee
    );

    /// @dev Error when invalid offer type
    error InvalidOfferType(OfferType _targetType, OfferType _currentType);

    /// @dev Error when invalid offer status
    error InvalidOfferStatus();

    /// @dev Error when invalid stock status
    error InvalidStockStatus();

    /// @dev Error when invalid market place status
    error InvaildMarketPlaceStatus();

    /// @dev Error when invalid stock
    error InvalidStock();

    /// @dev Error when invalid stock type
    error InvalidStockType();

    /// @dev Error when insufficient remaining points
    error InsufficientRemainingPoints();

    /// @dev Error when invalid points
    error InvalidPoints();

    /// @dev Error when fixed ratio unsupported
    error FixedRatioUnsupported();
}

// src/interfaces/IPerMarkets.sol

/**
 * @title IPerMarkets
 * @dev Interface of PerMarkets
 */
interface IPerMarkets {
    /**
     * @dev Get offer info by offer address
     * @param _offer offer address
     */
    function getOfferInfo(
        address _offer
    ) external view returns (OfferInfo memory _offerInfo);

    /**
     * @dev Get stock info by stock address
     * @param _stock stock address
     */
    function getStockInfo(
        address _stock
    ) external view returns (StockInfo memory _stockInfo);

    /**
     * @dev Get maker info by maker address
     * @param _maker maker address
     */
    function getMakerInfo(
        address _maker
    ) external view returns (MakerInfo memory _makerInfo);

    /**
     * @dev Update offer status
     * @notice Only called by DeliveryPlace
     * @param _offer offer address
     * @param _status new status
     */
    function updateOfferStatus(address _offer, OfferStatus _status) external;

    /**
     * @dev Update stock status
     * @notice Only called by DeliveryPlace
     * @param _stock stock address
     * @param _status new status
     */
    function updateStockStatus(address _stock, StockStatus _status) external;

    /**
     * @dev Settled ask offer
     * @notice Only called by DeliveryPlace
     * @param _offer offer address
     * @param _settledPoints settled points
     * @param _settledPointTokenAmount settled point token amount
     */
    function settledAskOffer(
        address _offer,
        uint256 _settledPoints,
        uint256 _settledPointTokenAmount
    ) external;

    /**
     * @dev Settle ask taker
     * @notice Only called by DeliveryPlace
     * @param _offer offer address
     * @param _stock stock address
     * @param _settledPoints settled points
     * @param _settledPointTokenAmount settled point token amount
     */
    function settleAskTaker(
        address _offer,
        address _stock,
        uint256 _settledPoints,
        uint256 _settledPointTokenAmount
    ) external;

    /// @dev Event when offer created
    event CreateOffer(
        address indexed _offer,
        address indexed _maker,
        address indexed _stock,
        address _marketPlace,
        address _authority,
        uint256 _points,
        uint256 _amount
    );

    /// @dev Event when taker created
    event CreateTaker(
        address indexed offer,
        address authority,
        address stock,
        uint256 points,
        uint256 amount,
        uint256 tradeTax,
        uint256 platformFee
    );

    /// @dev Event when referrer updated
    event ReferralBonus(
        address indexed stock,
        address authority,
        address referrer,
        uint256 authorityReferralBonus,
        uint256 referrerReferralBonus,
        uint256 tradingVolume,
        uint256 tradingFee
    );

    /// @dev Event when offer listed
    event ListOffer(
        address indexed offer,
        address indexed stock,
        address authority,
        uint256 points,
        uint256 amount
    );

    /// @dev Event when offer closed
    event CloseOffer(address indexed offer, address indexed authority);

    /// @dev Event when offer relisted
    event RelistOffer(address indexed offer, address indexed authority);

    /// @dev Event when offer aborted
    event AbortAskOffer(address indexed offer, address indexed authority);

    /// @dev Event when taker aborted
    event AbortBidTaker(address indexed stock, address indexed authority);

    /// @dev Event when offer status updated
    event OfferStatusUpdated(address _offer, OfferStatus _status);

    /// @dev Event when stock status updated
    event StockStatusUpdated(address _stock, StockStatus _status);

    /// @dev Event when ask offer settled
    event SettledAskOffer(
        address _offer,
        uint256 _settledPoints,
        uint256 _settledPointTokenAmount
    );

    /// @dev Event when ask taker settled
    event SettledBidTaker(
        address _offer,
        address _stock,
        uint256 _settledPoints,
        uint256 _settledPointTokenAmount
    );

    /// @dev Error when invalid each trade tax rate
    error InvalidEachTradeTaxRate();

    /// @dev Error when invalid collateral rate
    error InvalidCollateralRate();

    /// @dev Error when invalid offer account
    error InvalidOfferAccount(address _targetAccount, address _currentAccount);

    /// @dev Error when maker is already exist
    error MakerAlreadyExist();

    /// @dev Error when offer is already exist
    error OfferAlreadyExist();

    /// @dev Error when stock is already exist
    error StockAlreadyExist();

    /// @dev Error when invalid offer
    error InvalidOffer();

    /// @dev Error when invalid offer type
    error InvalidOfferType(OfferType _targetType, OfferType _currentType);

    /// @dev Error when invalid stock status
    error InvalidStockType(StockType _targetType, StockType _currentType);

    /// @dev Error when invalid offer status
    error InvalidOfferStatus();

    /// @dev Error when invalid offer status
    error InvalidAbortOfferStatus(
        AbortOfferStatus _targetStatus,
        AbortOfferStatus _currentStatus
    );

    /// @dev Error when invalid stock status
    error InvalidStockStatus(
        StockStatus _targetStatus,
        StockStatus _currentStatus
    );

    /// @dev Error when not enough points
    error NotEnoughPoints(
        uint256 _totalPoints,
        uint256 _usedPoints,
        uint256 _points
    );
}

/**
 * @title MakerInfo
 * @dev Struct of MakerInfo
 * @notice offerSettleType, authority, marketPlace, tokenAddress, originOffer, platformFee, eachTradeTax
 * @param offerSettleType the settle type of offer.
 * @param authority the owner of maker, same as the authority of originOffer.
 * @param marketPlace the marketPlace of maker.
 */
struct MakerInfo {
    OfferSettleType offerSettleType;
    address authority;
    address marketPlace;
    address tokenAddress;
    address originOffer;
    uint256 platformFee;
    uint256 eachTradeTax;
}

/**
 * @title OfferInfo
 * @dev Struct of OfferInfo
 * @param id the unique id of offer.
 * @param authority the owner of offer.
 * @param maker the maker of offer, is a virtual address, storage as MakerInfo.
 * @param offerStatus the status of offer, detail in OfferStatus.sol.
 * @param offerType the type of offer, detail in OfferStatus.sol.
 * @param abortOfferStatus the status of abort offer, detail in OfferStatus.sol.
 * @param points the points of sell or buy offer.
 * @param amount the amount want to sell or buy.
 * @param collateralRate the collateral rate of offer. must be greater than 100%. decimal is 10000.
 * @param usedPoints the points that already completed.
 * @param tradeTax the trade tax of offer. decimal is 10000.
 * @param settledPoints the settled points of offer.
 * @param settledPointTokenAmount the settled point token amount of offer.
 * @param settledCollateralAmount the settled collateral amount of offer.
 */
struct OfferInfo {
    uint256 id;
    address authority;
    address maker;
    OfferStatus offerStatus;
    OfferType offerType;
    AbortOfferStatus abortOfferStatus;
    uint256 points;
    uint256 amount;
    uint256 collateralRate;
    uint256 usedPoints;
    uint256 tradeTax;
    uint256 settledPoints;
    uint256 settledPointTokenAmount;
    uint256 settledCollateralAmount;
}

/**
 * @title StockInfo
 * @dev Struct of StockInfo
 * @notice id, stockStatus, stockType, authority, maker, preOffer, points, amount, offer
 * @param id the unique id of stock.
 * @param stockStatus the status of stock, detail in OfferStatus.sol.
 * @param stockType the type of stock, detail in OfferStatus.sol.
 * @param authority the owner of stock.
 * @param maker the maker of stock, is a virtual address, storage as MakerInfo.
 * @param preOffer the preOffer of stock.
 * @param points the points of sell or buy stock.
 * @param amount receive or used collateral amount when sell or buy.
 * @param offer the offer of stock, is a virtual address, storage as OfferInfo.
 */
struct StockInfo {
    uint256 id;
    StockStatus stockStatus;
    StockType stockType;
    address authority;
    address maker;
    address preOffer;
    uint256 points;
    uint256 amount;
    address offer;
}

/**
 * @title CreateOfferParams
 * @dev Struct of CreateOfferParams
 * @notice marketPlace, tokenAddress, points, amount, collateralRate, eachTradeTax, offerType, offerSettleType
 * @param marketPlace the marketPlace of offer.
 * @param tokenAddress the collateral token address of offer.
 * @param points the points of sell or buy offer.
 * @param amount the amount want to sell or buy.
 * @param collateralRate the collateral rate of offer. must be greater than 100%. decimal is 10000.
 * @param eachTradeTax the trade tax of offer. decimal is 10000.
 * @param offerType the type of offer, detail in OfferType.sol.
 * @param offerSettleType the settle type of offer, detail in OfferSettleType.sol.
 */
struct CreateOfferParams {
    address marketPlace;
    address tokenAddress;
    uint256 points;
    uint256 amount;
    uint256 collateralRate;
    uint256 eachTradeTax;
    OfferType offerType;
    OfferSettleType offerSettleType;
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

// src/storage/CapitalPoolStorage.sol

/**
 * @title CapitalPoolStorage
 * @notice This contrct serves as the storage of CapitalPool
 * @notice The top 50 storage slots are used for upgradeable storage.
 * @notice The 50th to 150th storage slots are used for CapitalPool.
 */
contract CapitalPoolStorage is UpgradeableStorage {
    /// @dev empty reserved space is put in place to allow future versions to add new
    /// variables without shifting down storage in the inheritance chain.
    /// See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
    /// start from slot 50, end at slot 149
    uint256[100] private __gap;
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

// src/libraries/RelatedContractLibraries.sol

/**
 * @title RelatedContractLibraries
 * @dev Library of related contracts
 * @dev Get interface of related contract from TadleFactory
 * @notice Add new related contract here
 */
library RelatedContractLibraries {
    uint8 internal constant SYSTEM_CONFIG = 1;
    uint8 internal constant PRE_MARKETS = 2;
    uint8 internal constant DELIVERY_PLACE = 3;
    uint8 internal constant CAPITAL_POOL = 4;
    uint8 internal constant TOKEN_MANAGER = 5;

    
    /// @dev Get interface of system config
    function getSystemConfig(
        ITadleFactory _tadleFactory
    ) internal view returns (ISystemConfig) {
        return ISystemConfig(_tadleFactory.relatedContracts(SYSTEM_CONFIG));
    }

    /// @dev Get interface of per markets
    function getPerMarkets(
        ITadleFactory _tadleFactory
    ) internal view returns (IPerMarkets) {
        return IPerMarkets(_tadleFactory.relatedContracts(PRE_MARKETS));
    }

    /// @dev Get interface of delivery place
    function getDeliveryPlace(
        ITadleFactory _tadleFactory
    ) internal view returns (IDeliveryPlace) {
        return IDeliveryPlace(_tadleFactory.relatedContracts(DELIVERY_PLACE));
    }

    /// @dev Get interface of capital pool
    function getCapitalPool(
        ITadleFactory _tadleFactory
    ) internal view returns (ICapitalPool) {
        return ICapitalPool(_tadleFactory.relatedContracts(CAPITAL_POOL));
    }

    /// @dev Get interface of token manager
    function getTokenManager(
        ITadleFactory _tadleFactory
    ) internal view returns (ITokenManager) {
        return ITokenManager(_tadleFactory.relatedContracts(TOKEN_MANAGER));
    }
}

// src/core/CapitalPool.sol

/**
 * @title CapitalPool
 * @notice Implement the capital pool
 */
contract CapitalPool is CapitalPoolStorage, Rescuable, ICapitalPool {
    bytes4 private constant APPROVE_SELECTOR =
        bytes4(keccak256(bytes("approve(address,uint256)")));

    constructor() Rescuable() {}

    /**
     * @dev Approve token for token manager
     * @notice only can be called by token manager
     * @param tokenAddr address of token
     */
    function approve(address tokenAddr) external {
        address tokenManager = tadleFactory.relatedContracts(
            RelatedContractLibraries.TOKEN_MANAGER
        );
        (bool success, ) = tokenAddr.call(
            abi.encodeWithSelector(
                APPROVE_SELECTOR,
                tokenManager,
                type(uint256).max
            )
        );

        if (!success) {
            revert ApproveFailed();
        }
    }
}
