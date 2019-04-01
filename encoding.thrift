/**
    Thrift file with common definitions for RIFT
*/


/** @note MUST be interpreted in implementation as unsigned 64 bits.
 *        The implementation SHOULD NOT use the MSB.
 */
typedef i64      SystemIDType
typedef i32      IPv4Address
/** this has to be of length long enough to accomodate prefix */
typedef binary   IPv6Address
/** @note MUST be interpreted in implementation as unsigned */
typedef i16      UDPPortType
/** @note MUST be interpreted in implementation as unsigned */
typedef i32      TIENrType
/** @note MUST be interpreted in implementation as unsigned */
typedef i32      MTUSizeType
/** @note MUST be interpreted in implementation as unsigned rollling over number */
typedef i16      SeqNrType
/** @note MUST be interpreted in implementation as unsigned */
typedef i32      LifeTimeInSecType
/** @note MUST be interpreted in implementation as unsigned */
typedef i8       LevelType
/** optional, recommended monotonically increasing number _per packet type per adjacency_
    that can be used to detect losses/misordering/restarts.
    This will be moved into envelope in the future.
    @note MUST be interpreted in implementation as unsigned rollling over number */
typedef i16      PacketNumberType
/** @note MUST be interpreted in implementation as unsigned */
typedef i32      PodType
/** @note MUST be interpreted in implementation as unsigned. This is carried in the
          security envelope and MUST fit into 8 bits. */
typedef i8       VersionType
/** @note MUST be interpreted in implementation as unsigned */
typedef i16      MinorVersionType
/** @note MUST be interpreted in implementation as unsigned */
typedef i32      MetricType
/** @note MUST be interpreted in implementation as unsigned and unstructured */
typedef i64      RouteTagType
/** @note MUST be interpreted in implementation as unstructured label value */
typedef i32      LabelType
/** @note MUST be interpreted in implementation as unsigned */
typedef i32      BandwithInMegaBitsType
typedef string   KeyIDType
/** node local, unique identification for a link (interface/tunnel
  * etc. Basically anything RIFT runs on). This is kept
  * at 32 bits so it aligns with BFD [RFC5880] discriminator size.
  */
typedef i32    LinkIDType
typedef string KeyNameType
typedef i8     PrefixLenType
/** timestamp in seconds since the epoch */
typedef i64    TimestampInSecsType
/** security nonce.
 *  @note MUST be interpreted in implementation as rolling over unsigned value */
typedef i16    NonceType
/** LIE FSM holdtime type */
typedef i16    TimeIntervalInSecType
/** Transaction ID type for prefix mobility as specified by RFC6550,  value
    MUST be interpreted in implementation as unsigned  */
typedef i8     PrefixTransactionIDType
/** timestamp per IEEE 802.1AS, values MUST be interpreted in implementation as unsigned  */
struct IEEE802_1ASTimeStampType {
    1: required     i64     AS_sec;
    2: optional     i32     AS_nsec;
}

/** Flags indicating nodes behavior in case of ZTP and support
    for special optimization procedures. It will force level to `leaf_level` or
    `top-of-fabric` level accordingly and enable according procedures
 */
enum HierarchyIndications {
    leaf_only                            = 0,
    leaf_only_and_leaf_2_leaf_procedures = 1,
    top_of_fabric                        = 2,
}

const PacketNumberType  undefined_packet_number    = 0
/** This MUST be used when node is configured as top of fabric in ZTP.
    This is kept reasonably low to alow for fast ZTP convergence on
    failures. */
const LevelType   top_of_fabric_level              = 24
/** default bandwidth on a link */
const BandwithInMegaBitsType  default_bandwidth    = 100
/** fixed leaf level when ZTP is not used */
const LevelType   leaf_level                  = 0
const LevelType   default_level               = leaf_level
const PodType     default_pod                 = 0
const LinkIDType  undefined_linkid            = 0

/** default distance used */
const MetricType  default_distance         = 1
/** any distance larger than this will be considered infinity */
const MetricType  infinite_distance       = 0x7FFFFFFF
/** represents invalid distance */
const MetricType  invalid_distance        = 0
const bool overload_default               = false
const bool flood_reduction_default        = true
/** default LIE FSM holddown time */
const TimeIntervalInSecType   default_lie_holdtime  = 3
/** default ZTP FSM holddown time */
const TimeIntervalInSecType   default_ztp_holdtime  = 1
/** by default LIE levels are ZTP offers */
const bool default_not_a_ztp_offer        = false
/** by default e'one is repeating flooding */
const bool default_you_are_flood_repeater = true
/** 0 is illegal for SystemID */
const SystemIDType IllegalSystemID        = 0
/** empty set of nodes */
const set<SystemIDType> empty_set_of_nodeids = {}
/** default lifetime of TIE is one week */
const LifeTimeInSecType default_lifetime      = 604800
/** default lifetime when TIEs are purged is 5 minutes */
const LifeTimeInSecType purge_lifetime        = 300
/** round down interval when TIEs are sent with security hashes
    to prevent excessive computation. **/
const LifeTimeInSecType rounddown_lifetime_interval = 60
/** any `TieHeader` that has a smaller lifetime difference
    than this constant is equal (if other fields equal). This
    constant MUST be larger than `purge_lifetime` to avoid
    retransmissions */
const LifeTimeInSecType lifetime_diff2ignore  = 400

/** default UDP port to run LIEs on */
const UDPPortType     default_lie_udp_port       =  911
/** default UDP port to receive TIEs on, that can be peer specific */
const UDPPortType     default_tie_udp_flood_port =  912

/** default MTU link size to use */
const MTUSizeType     default_mtu_size           = 1400
/** default link being BFD capable */
const bool            bfd_default                = true

/** undefined nonce, equivalent to missing nonce */
const NonceType       undefined_nonce            = 0;
/** Maximum delta (negative or positive) that a mirrored nonce can
    deviate from local value to be considered valid. If nonces are
    changed every minute on both sides this opens statistically
    a 5 minutes window of identical LIEs **/
const i16             maximum_valid_nonce_delta  = 5;

/** indicates whether the direction is northbound/east-west
  * or southbound */
enum TieDirectionType {
    Illegal           = 0,
    South             = 1,
    North             = 2,
    DirectionMaxValue = 3,
}

enum AddressFamilyType {
   Illegal                = 0,
   AddressFamilyMinValue  = 1,
   IPv4     = 2,
   IPv6     = 3,
   AddressFamilyMaxValue  = 4,
}

struct IPv4PrefixType {
    1: required IPv4Address    address;
    2: required PrefixLenType  prefixlen;
}

struct IPv6PrefixType {
    1: required IPv6Address    address;
    2: required PrefixLenType  prefixlen;
}

union IPAddressType {
    1: optional IPv4Address   ipv4address;
    2: optional IPv6Address   ipv6address;
}

union IPPrefixType {
    1: optional IPv4PrefixType   ipv4prefix;
    2: optional IPv6PrefixType   ipv6prefix;
}

/** @note: Sequence of a prefix. Comparison function:
    if diff(timestamps) < 200msecs better transactionid wins
    else better time wins
 */
struct PrefixSequenceType {
    1: required IEEE802_1ASTimeStampType  timestamp;
    2: optional PrefixTransactionIDType   transactionid;
}

/** Type of TIE.

    This enum indicates what TIE type the TIE is carrying.
    In case the value is not known to the receiver,
    re-flooded the same way as prefix TIEs. This allows for
    future extensions of the protocol within the same schema major
    with types opaque to some nodes unless the flooding scope is not
    the same as prefix TIE, then a major version revision MUST
    be performed.
*/
enum TIETypeType {
    Illegal                             = 0,
    TIETypeMinValue                     = 1,
    /** first legal value */
    NodeTIEType                         = 2,
    PrefixTIEType                       = 3,
    PositiveDisaggregationPrefixTIEType = 4,
    NegativeDisaggregationPrefixTIEType = 5,
    PGPrefixTIEType                     = 6,
    KeyValueTIEType                     = 7,
    ExternalPrefixTIEType               = 8,
    TIETypeMaxValue                     = 9,
}

/** @note: route types which MUST be ordered on their preference
 *  PGP prefixes are most preferred attracting
 *  traffic north (towards spine) and then south
 *  normal prefixes are attracting traffic south (towards leafs),
 *  i.e. prefix in NORTH PREFIX TIE is preferred over SOUTH PREFIX TIE
 *
 *  @note: The only purpose of those values is to introduce an
 *         ordering whereas an implementation can choose internally
 *         any other values as long the ordering is preserved
 */
enum RouteType {
    Illegal               =  0,
    RouteTypeMinValue     =  1,
    /** First legal value. */
    /** Discard routes are most prefered */
    Discard               =  2,

    /** Local prefixes are directly attached prefixes on the
     *  system such as e.g. interface routes.
     */
    LocalPrefix           =  3,
    /** advertised in S-TIEs */
    SouthPGPPrefix        =  4,
    /** advertised in N-TIEs */
    NorthPGPPrefix        =  5,
    /** advertised in N-TIEs */
    NorthPrefix           =  6,
    /** externally imported north */
    NorthExternalPrefix   =  7,
    /** advertised in S-TIEs, either normal prefix or positive disaggregation */
    SouthPrefix           =  8,
    /** externally imported south */
    SouthExternalPrefix   =  9,
    /** negative, transitive prefixes are least preferred of
        local variety */
    NegativeSouthPrefix   = 10,
    RouteTypeMaxValue     = 11,
}
