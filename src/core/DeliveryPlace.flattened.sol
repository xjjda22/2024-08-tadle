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

// lib/openzeppelin-contracts/contracts/utils/math/Math.sol

// OpenZeppelin Contracts (last updated v5.0.0) (utils/math/Math.sol)

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Muldiv operation overflow.
     */
    error MathOverflowedMulDiv();

    enum Rounding {
        Floor, // Toward negative infinity
        Ceil, // Toward positive infinity
        Trunc, // Toward zero
        Expand // Away from zero
    }

    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds towards infinity instead
     * of rounding towards zero.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        if (b == 0) {
            // Guarantee the same behavior as in a regular Solidity division.
            return a / b;
        }

        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a == 0 ? 0 : (a - 1) / b + 1;
    }

    /**
     * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or
     * denominator == 0.
     * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv) with further edits by
     * Uniswap Labs also under MIT license.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
        unchecked {
            // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
            // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
            // variables such that product = prod1 * 2^256 + prod0.
            uint256 prod0 = x * y; // Least significant 256 bits of the product
            uint256 prod1; // Most significant 256 bits of the product
            assembly {
                let mm := mulmod(x, y, not(0))
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }

            // Handle non-overflow cases, 256 by 256 division.
            if (prod1 == 0) {
                // Solidity will revert if denominator == 0, unlike the div opcode on its own.
                // The surrounding unchecked block does not change this fact.
                // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
                return prod0 / denominator;
            }

            // Make sure the result is less than 2^256. Also prevents denominator == 0.
            if (denominator <= prod1) {
                revert MathOverflowedMulDiv();
            }

            ///////////////////////////////////////////////
            // 512 by 256 division.
            ///////////////////////////////////////////////

            // Make division exact by subtracting the remainder from [prod1 prod0].
            uint256 remainder;
            assembly {
                // Compute remainder using mulmod.
                remainder := mulmod(x, y, denominator)

                // Subtract 256 bit number from 512 bit number.
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }

            // Factor powers of two out of denominator and compute largest power of two divisor of denominator.
            // Always >= 1. See https://cs.stackexchange.com/q/138556/92363.

            uint256 twos = denominator & (0 - denominator);
            assembly {
                // Divide denominator by twos.
                denominator := div(denominator, twos)

                // Divide [prod1 prod0] by twos.
                prod0 := div(prod0, twos)

                // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from prod1 into prod0.
            prod0 |= prod1 * twos;

            // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
            // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv = 1 mod 2^4.
            uint256 inverse = (3 * denominator) ^ 2;

            // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also
            // works in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2^8
            inverse *= 2 - denominator * inverse; // inverse mod 2^16
            inverse *= 2 - denominator * inverse; // inverse mod 2^32
            inverse *= 2 - denominator * inverse; // inverse mod 2^64
            inverse *= 2 - denominator * inverse; // inverse mod 2^128
            inverse *= 2 - denominator * inverse; // inverse mod 2^256

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
            // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inverse;
            return result;
        }
    }

    /**
     * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
        uint256 result = mulDiv(x, y, denominator);
        if (unsignedRoundsUp(rounding) && mulmod(x, y, denominator) > 0) {
            result += 1;
        }
        return result;
    }

    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded
     * towards zero.
     *
     * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
     */
    function sqrt(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
        //
        // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
        // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
        //
        // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
        // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
        // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
        //
        // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
        uint256 result = 1 << (log2(a) >> 1);

        // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
        // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
        // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
        // into the expected uint128 result.
        unchecked {
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            return min(result, a / result);
        }
    }

    /**
     * @notice Calculates sqrt(a), following the selected rounding direction.
     */
    function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = sqrt(a);
            return result + (unsignedRoundsUp(rounding) && result * result < a ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 2 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     */
    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 128;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 64;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 32;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 16;
            }
            if (value >> 8 > 0) {
                value >>= 8;
                result += 8;
            }
            if (value >> 4 > 0) {
                value >>= 4;
                result += 4;
            }
            if (value >> 2 > 0) {
                value >>= 2;
                result += 2;
            }
            if (value >> 1 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log2(value);
            return result + (unsignedRoundsUp(rounding) && 1 << result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 10 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     */
    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10 ** 64) {
                value /= 10 ** 64;
                result += 64;
            }
            if (value >= 10 ** 32) {
                value /= 10 ** 32;
                result += 32;
            }
            if (value >= 10 ** 16) {
                value /= 10 ** 16;
                result += 16;
            }
            if (value >= 10 ** 8) {
                value /= 10 ** 8;
                result += 8;
            }
            if (value >= 10 ** 4) {
                value /= 10 ** 4;
                result += 4;
            }
            if (value >= 10 ** 2) {
                value /= 10 ** 2;
                result += 2;
            }
            if (value >= 10 ** 1) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log10(value);
            return result + (unsignedRoundsUp(rounding) && 10 ** result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 256 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     *
     * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
     */
    function log256(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 16;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 8;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 4;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 2;
            }
            if (value >> 8 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return result + (unsignedRoundsUp(rounding) && 1 << (result << 3) < value ? 1 : 0);
        }
    }

    /**
     * @dev Returns whether a provided rounding mode is considered rounding up for unsigned integers.
     */
    function unsignedRoundsUp(Rounding rounding) internal pure returns (bool) {
        return uint8(rounding) % 2 == 1;
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

// src/libraries/MarketPlaceLibraries.sol

/**
 * @title MarketPlaceLibraries
 * @dev Library of market place
 * @dev Get status of market place
 * @dev Check status of market place
 */
library MarketPlaceLibraries {
    /**
     * @dev Get status of market place
     * @param _blockTimestamp block timestamp
     * @param _marketPlaceInfo market place info
     * @dev block timestamp is larger than tge + settlementPeriod, return BidSettling
     * @dev block timestamp is larger than tge, return AskSettling
     */
    function getMarketPlaceStatus(
        uint256 _blockTimestamp,
        MarketPlaceInfo memory _marketPlaceInfo
    ) internal pure returns (MarketPlaceStatus _status) {
        if (_marketPlaceInfo.status == MarketPlaceStatus.Offline) {
            return MarketPlaceStatus.Offline;
        }

        /// @dev settle not active
        if (_marketPlaceInfo.tge == 0) {
            return _marketPlaceInfo.status;
        }

        if (
            _blockTimestamp >
            _marketPlaceInfo.tge + _marketPlaceInfo.settlementPeriod
        ) {
            return MarketPlaceStatus.BidSettling;
        }

        if (_blockTimestamp > _marketPlaceInfo.tge) {
            return MarketPlaceStatus.AskSettling;
        }

        return _marketPlaceInfo.status;
    }

    /**
     * @dev Check status of market place
     * @param _blockTimestamp block timestamp
     * @param _marketPlaceInfo market place info
     * @param _status status
     * @dev true if market status == _status
     */
    function checkMarketPlaceStatus(
        MarketPlaceInfo memory _marketPlaceInfo,
        uint256 _blockTimestamp,
        MarketPlaceStatus _status
    ) internal pure {
        MarketPlaceStatus status = getMarketPlaceStatus(
            _blockTimestamp,
            _marketPlaceInfo
        );

        if (status != _status) {
            revert("Mismatched Marketplace status");
        }
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

// src/storage/DeliveryPlaceStorage.sol

/**
 * @title DeliveryPlaceStorage
 * @notice This contrct serves as the storage of DeliveryPlace
 * @notice The top 50 storage slots are used for upgradeable storage.
 * @notice The 50th to 150th storage slots are used for DeliveryPlace.
 */
contract DeliveryPlaceStorage is UpgradeableStorage {
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

// src/libraries/OfferLibraries.sol

/**
 * @title OfferLibraries
 * @dev Library of offer
 * @dev Get deposit amount
 * @dev Get refund amount
 */
library OfferLibraries {
    /**
     * @dev Get deposit amount
     * @dev if create ask offer, return _amount * _collateralRate;
     * @dev if create bid offer, return _amount;
     * @dev if create ask order, return _amount;
     * @dev if create bid order, return _amount * _collateralRate;
     * @param _offerType offer type
     * @param _collateralRate collateral rate
     * @param _amount amount
     * @param _isMaker is maker, true if create offer, false if create offer
     * @param _rounding rounding
     */
    function getDepositAmount(
        OfferType _offerType,
        uint256 _collateralRate,
        uint256 _amount,
        bool _isMaker,
        Math.Rounding _rounding
    ) internal pure returns (uint256) {
        /// @dev bid offer
        if (_offerType == OfferType.Bid && _isMaker) {
            return _amount;
        }

        /// @dev ask order
        if (_offerType == OfferType.Ask && !_isMaker) {
            return _amount;
        }

        return
            Math.mulDiv(
                _amount,
                _collateralRate,
                Constants.COLLATERAL_RATE_DECIMAL_SCALER,
                _rounding
            );
    }

    /**
     * @dev Get refund amount, offer type
     * @dev if close bid offer, return offer amount - used amount;
     * @dev if close ask offer, return (offer amount - used amount) * collateralRate;
     * @param _offerType offer type
     * @param _amount amount
     * @param _points points
     * @param _usedPoints used points
     * @param _collateralRate collateral rate
     */
    function getRefundAmount(
        OfferType _offerType,
        uint256 _amount,
        uint256 _points,
        uint256 _usedPoints,
        uint256 _collateralRate
    ) internal pure returns (uint256) {
        uint256 usedAmount = Math.mulDiv(
            _amount,
            _usedPoints,
            _points,
            Math.Rounding.Ceil
        );

        if (_offerType == OfferType.Bid) {
            return _amount - usedAmount;
        }

        return
            Math.mulDiv(
                _amount - usedAmount,
                _collateralRate,
                Constants.COLLATERAL_RATE_DECIMAL_SCALER,
                Math.Rounding.Floor
            );
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

// src/core/DeliveryPlace.sol

/**
 * @title DeliveryPlace
 * @notice Implement the delivery place
 */
contract DeliveryPlace is DeliveryPlaceStorage, Rescuable, IDeliveryPlace {
    using Math for uint256;
    using RelatedContractLibraries for ITadleFactory;

    constructor() Rescuable() {}

    /**
     * @notice Close bid offer
     * @dev caller must be offer authority
     * @dev offer type must Bid
     * @dev offer status must be Settling
     * @dev refund amount = offer amount - used amount
     */
    function closeBidOffer(address _offer) external {
        (
            OfferInfo memory offerInfo,
            MakerInfo memory makerInfo,
            ,
            MarketPlaceStatus status
        ) = getOfferInfo(_offer);

        if (_msgSender() != offerInfo.authority) {
            revert Errors.Unauthorized();
        }

        if (offerInfo.offerType == OfferType.Ask) {
            revert InvalidOfferType(OfferType.Bid, OfferType.Ask);
        }

        if (
            status != MarketPlaceStatus.AskSettling &&
            status != MarketPlaceStatus.BidSettling
        ) {
            revert InvaildMarketPlaceStatus();
        }

        if (offerInfo.offerStatus != OfferStatus.Virgin) {
            revert InvalidOfferStatus();
        }

        uint256 refundAmount = OfferLibraries.getRefundAmount(
            offerInfo.offerType,
            offerInfo.amount,
            offerInfo.points,
            offerInfo.usedPoints,
            offerInfo.collateralRate
        );

        ITokenManager tokenManager = tadleFactory.getTokenManager();
        tokenManager.addTokenBalance(
            TokenBalanceType.MakerRefund,
            _msgSender(),
            makerInfo.tokenAddress,
            refundAmount
        );

        IPerMarkets perMarkets = tadleFactory.getPerMarkets();
        perMarkets.updateOfferStatus(_offer, OfferStatus.Settled);

        emit CloseBidOffer(
            makerInfo.marketPlace,
            offerInfo.maker,
            _offer,
            _msgSender()
        );
    }

    /**
     * @notice Close bid taker
     * @dev caller must be stock authority
     * @dev stock type must Bid
     * @dev offer status must be Settled
     * @param _stock stock address
     */
    function closeBidTaker(address _stock) external {
        IPerMarkets perMarkets = tadleFactory.getPerMarkets();
        ITokenManager tokenManager = tadleFactory.getTokenManager();
        StockInfo memory stockInfo = perMarkets.getStockInfo(_stock);

        if (stockInfo.preOffer == address(0x0)) {
            revert InvalidStock();
        }

        if (stockInfo.stockType == StockType.Ask) {
            revert InvalidStockType();
        }

        if (_msgSender() != stockInfo.authority) {
            revert Errors.Unauthorized();
        }

        (
            OfferInfo memory preOfferInfo,
            MakerInfo memory makerInfo,
            ,

        ) = getOfferInfo(stockInfo.preOffer);

        OfferInfo memory offerInfo;
        uint256 userRemainingPoints;
        if (makerInfo.offerSettleType == OfferSettleType.Protected) {
            offerInfo = preOfferInfo;
            userRemainingPoints = stockInfo.points;
        } else {
            offerInfo = perMarkets.getOfferInfo(makerInfo.originOffer);
            if (stockInfo.offer == address(0x0)) {
                userRemainingPoints = stockInfo.points;
            } else {
                OfferInfo memory listOfferInfo = perMarkets.getOfferInfo(
                    stockInfo.offer
                );
                userRemainingPoints =
                    listOfferInfo.points -
                    listOfferInfo.usedPoints;
            }
        }

        if (userRemainingPoints == 0) {
            revert InsufficientRemainingPoints();
        }

        if (offerInfo.offerStatus != OfferStatus.Settled) {
            revert InvalidOfferStatus();
        }

        if (stockInfo.stockStatus != StockStatus.Initialized) {
            revert InvalidStockStatus();
        }

        uint256 collateralFee;
        if (offerInfo.usedPoints > offerInfo.settledPoints) {
            if (offerInfo.offerStatus == OfferStatus.Virgin) {
                collateralFee = OfferLibraries.getDepositAmount(
                    offerInfo.offerType,
                    offerInfo.collateralRate,
                    offerInfo.amount,
                    true,
                    Math.Rounding.Floor
                );
            } else {
                uint256 usedAmount = offerInfo.amount.mulDiv(
                    offerInfo.usedPoints,
                    offerInfo.points,
                    Math.Rounding.Floor
                );

                collateralFee = OfferLibraries.getDepositAmount(
                    offerInfo.offerType,
                    offerInfo.collateralRate,
                    usedAmount,
                    true,
                    Math.Rounding.Floor
                );
            }
        }

        uint256 userCollateralFee = collateralFee.mulDiv(
            userRemainingPoints,
            offerInfo.usedPoints,
            Math.Rounding.Floor
        );

        tokenManager.addTokenBalance(
            TokenBalanceType.RemainingCash,
            _msgSender(),
            makerInfo.tokenAddress,
            userCollateralFee
        );
        uint256 pointTokenAmount = offerInfo.settledPointTokenAmount.mulDiv(
            userRemainingPoints,
            offerInfo.usedPoints,
            Math.Rounding.Floor
        );
        tokenManager.addTokenBalance(
            TokenBalanceType.PointToken,
            _msgSender(),
            makerInfo.tokenAddress,
            pointTokenAmount
        );

        perMarkets.updateStockStatus(_stock, StockStatus.Finished);

        emit CloseBidTaker(
            makerInfo.marketPlace,
            offerInfo.maker,
            _stock,
            _msgSender(),
            userCollateralFee,
            pointTokenAmount
        );
    }

    /**
     * @notice Settle ask maker
     * @dev caller must be offer authority
     * @dev offer status must be Virgin or Canceled
     * @dev market place status must be AskSettling
     * @param _offer offer address
     * @param _settledPoints settled points
     */
    function settleAskMaker(address _offer, uint256 _settledPoints) external {
        (
            OfferInfo memory offerInfo,
            MakerInfo memory makerInfo,
            MarketPlaceInfo memory marketPlaceInfo,
            MarketPlaceStatus status
        ) = getOfferInfo(_offer);

        if (_settledPoints > offerInfo.usedPoints) {
            revert InvalidPoints();
        }

        if (marketPlaceInfo.fixedratio) {
            revert FixedRatioUnsupported();
        }

        if (offerInfo.offerType == OfferType.Bid) {
            revert InvalidOfferType(OfferType.Ask, OfferType.Bid);
        }

        if (
            offerInfo.offerStatus != OfferStatus.Virgin &&
            offerInfo.offerStatus != OfferStatus.Canceled
        ) {
            revert InvalidOfferStatus();
        }

        if (status == MarketPlaceStatus.AskSettling) {
            if (_msgSender() != offerInfo.authority) {
                revert Errors.Unauthorized();
            }
        } else {
            if (_msgSender() != owner()) {
                revert Errors.Unauthorized();
            }
            if (_settledPoints > 0) {
                revert InvalidPoints();
            }
        }

        uint256 settledPointTokenAmount = marketPlaceInfo.tokenPerPoint *
            _settledPoints;

        ITokenManager tokenManager = tadleFactory.getTokenManager();
        if (settledPointTokenAmount > 0) {
            tokenManager.tillIn(
                _msgSender(),
                marketPlaceInfo.tokenAddress,
                settledPointTokenAmount,
                true
            );
        }

        uint256 makerRefundAmount;
        if (_settledPoints == offerInfo.usedPoints) {
            if (offerInfo.offerStatus == OfferStatus.Virgin) {
                makerRefundAmount = OfferLibraries.getDepositAmount(
                    offerInfo.offerType,
                    offerInfo.collateralRate,
                    offerInfo.amount,
                    true,
                    Math.Rounding.Floor
                );
            } else {
                uint256 usedAmount = offerInfo.amount.mulDiv(
                    offerInfo.usedPoints,
                    offerInfo.points,
                    Math.Rounding.Floor
                );

                makerRefundAmount = OfferLibraries.getDepositAmount(
                    offerInfo.offerType,
                    offerInfo.collateralRate,
                    usedAmount,
                    true,
                    Math.Rounding.Floor
                );
            }

            tokenManager.addTokenBalance(
                TokenBalanceType.SalesRevenue,
                _msgSender(),
                makerInfo.tokenAddress,
                makerRefundAmount
            );
        }

        IPerMarkets perMarkets = tadleFactory.getPerMarkets();
        perMarkets.settledAskOffer(
            _offer,
            _settledPoints,
            settledPointTokenAmount
        );

        emit SettleAskMaker(
            makerInfo.marketPlace,
            offerInfo.maker,
            _offer,
            _msgSender(),
            _settledPoints,
            settledPointTokenAmount,
            makerRefundAmount
        );
    }

    /**
     * @notice Settle ask taker
     * @dev caller must be stock authority
     * @dev market place status must be AskSettling
     * @param _stock stock address
     * @param _settledPoints settled points
     * @notice _settledPoints must be less than or equal to stock points
     */
    function settleAskTaker(address _stock, uint256 _settledPoints) external {
        IPerMarkets perMarkets = tadleFactory.getPerMarkets();
        StockInfo memory stockInfo = perMarkets.getStockInfo(_stock);

        (
            OfferInfo memory offerInfo,
            MakerInfo memory makerInfo,
            MarketPlaceInfo memory marketPlaceInfo,
            MarketPlaceStatus status
        ) = getOfferInfo(stockInfo.preOffer);

        if (stockInfo.stockStatus != StockStatus.Initialized) {
            revert InvalidStockStatus();
        }

        if (marketPlaceInfo.fixedratio) {
            revert FixedRatioUnsupported();
        }
        if (stockInfo.stockType == StockType.Bid) {
            revert InvalidStockType();
        }
        if (_settledPoints > stockInfo.points) {
            revert InvalidPoints();
        }

        if (status == MarketPlaceStatus.AskSettling) {
            if (_msgSender() != offerInfo.authority) {
                revert Errors.Unauthorized();
            }
        } else {
            if (_msgSender() != owner()) {
                revert Errors.Unauthorized();
            }
            if (_settledPoints > 0) {
                revert InvalidPoints();
            }
        }

        uint256 settledPointTokenAmount = marketPlaceInfo.tokenPerPoint *
            _settledPoints;
        ITokenManager tokenManager = tadleFactory.getTokenManager();
        if (settledPointTokenAmount > 0) {
            tokenManager.tillIn(
                _msgSender(),
                marketPlaceInfo.tokenAddress,
                settledPointTokenAmount,
                true
            );

            tokenManager.addTokenBalance(
                TokenBalanceType.PointToken,
                offerInfo.authority,
                makerInfo.tokenAddress,
                settledPointTokenAmount
            );
        }

        uint256 collateralFee = OfferLibraries.getDepositAmount(
            offerInfo.offerType,
            offerInfo.collateralRate,
            stockInfo.amount,
            false,
            Math.Rounding.Floor
        );

        if (_settledPoints == stockInfo.points) {
            tokenManager.addTokenBalance(
                TokenBalanceType.RemainingCash,
                _msgSender(),
                makerInfo.tokenAddress,
                collateralFee
            );
        } else {
            tokenManager.addTokenBalance(
                TokenBalanceType.MakerRefund,
                offerInfo.authority,
                makerInfo.tokenAddress,
                collateralFee
            );
        }

        perMarkets.settleAskTaker(
            stockInfo.preOffer,
            _stock,
            _settledPoints,
            settledPointTokenAmount
        );

        emit SettleAskTaker(
            makerInfo.marketPlace,
            offerInfo.maker,
            _stock,
            stockInfo.preOffer,
            _msgSender(),
            _settledPoints,
            settledPointTokenAmount,
            collateralFee
        );
    }

    function getOfferInfo(
        address _offer
    )
        internal
        view
        returns (
            OfferInfo memory offerInfo,
            MakerInfo memory makerInfo,
            MarketPlaceInfo memory marketPlaceInfo,
            MarketPlaceStatus status
        )
    {
        IPerMarkets perMarkets = tadleFactory.getPerMarkets();
        ISystemConfig systemConfig = tadleFactory.getSystemConfig();

        offerInfo = perMarkets.getOfferInfo(_offer);
        makerInfo = perMarkets.getMakerInfo(offerInfo.maker);
        marketPlaceInfo = systemConfig.getMarketPlaceInfo(
            makerInfo.marketPlace
        );

        status = MarketPlaceLibraries.getMarketPlaceStatus(
            block.timestamp,
            marketPlaceInfo
        );
    }
}
