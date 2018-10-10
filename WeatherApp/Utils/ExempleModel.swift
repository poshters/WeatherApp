//import RealmSwift
//
//final class EbayAccountSalePoints: Object, Decodable {
//    @objc dynamic var ebayId = 0
//
//    let chartPoints = List<ChartPoint>()
//    @objc dynamic var fromValue = 0.0
//    @objc dynamic var toValue = 0.0
//
//    @objc dynamic var totalSales = 0.0
//    @objc dynamic var totalRevenue = 0.0
//    @objc dynamic var totalFee = 0.0
//    @objc dynamic var totalProfit = 0.0
//
//    /// CodingKeys
//    enum CodingKeys: String, CodingKey {
//        case ebayId
//
//        case data
//        /// DataCodingKeys
//        enum DataCodingKeys: String, CodingKey {
//            case totalSales
//            case totalRevenue
//            case totalFee
//            case totalProfit
//
//            case draw
//            /// DrawCodingKeys
//            enum DrawCodingKeys: String, CodingKey {
//                case values
//                case from
//                case to
//            }
//        }
//    }
//
//    convenience init(from decoder: Decoder) throws {
//        self.init()
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.DataCodingKeys.self,
//                                                          forKey: .data)
//        let drawContainer = try dataContainer.nestedContainer(keyedBy: CodingKeys.DataCodingKeys.DrawCodingKeys.self,
//                                                              forKey: .draw)
//
//        ebayId = try container.decode(Int.self, forKey: .ebayId)
//
//        chartPoints.append(objectsIn: (try? drawContainer.decode([ChartPoint].self, forKey: .values)) ?? [])
//        fromValue = (try? drawContainer.decode(Double.self, forKey: .from)) ?? 0
//        toValue = (try? drawContainer.decode(Double.self, forKey: .to)) ?? 0
//
//        totalSales = (try? dataContainer.decode(Double.self, forKey: .totalSales)) ?? 0
//        totalRevenue = (try? dataContainer.decode(Double.self, forKey: .totalRevenue)) ?? 0
//        totalFee = (try? dataContainer.decode(Double.self, forKey: .totalFee)) ?? 0
//        totalProfit = (try? dataContainer.decode(Double.self, forKey: .totalProfit)) ?? 0.0
//    }
//}
//
//// MARK: - Comparable
//extension EbayAccountSalePoints: Comparable {
//    static func <(lhs: EbayAccountSalePoints, rhs: EbayAccountSalePoints) -> Bool {
//        return lhs.ebayId < rhs.ebayId
//    }
//
//    static func iEqualArray(lhs: [EbayAccountSalePoints], rhs: [EbayAccountSalePoints]) -> Bool {
//        let lhsElements = lhs.sorted()
//        let rhsElements = rhs.sorted()
//        guard lhsElements.count == rhsElements.count else {
//            return false
//        }
//        for i in 0 ..< lhsElements.count {
//            let lhsElement = lhsElements[i]
//            let rhsElement = rhsElements[i]
//            if lhsElement.ebayId != rhsElement.ebayId
//                || lhsElement.fromValue != rhsElement.fromValue
//                || lhsElement.toValue != rhsElement.toValue
//                || lhsElement.totalSales != rhsElement.totalSales
//                || lhsElement.totalRevenue != rhsElement.totalRevenue
//                || lhsElement.totalFee != rhsElement.totalFee
//                || lhsElement.totalProfit != rhsElement.totalProfit
//                || !ChartPoint.iEqualArrays(lhs: lhsElement.chartPoints.compactMap{ $0 as ChartPoint },
//                                            rhs: rhsElement.chartPoints.compactMap{ $0 as ChartPoint }) {
//                return false
//            }
//        }
//        return true
//    }
//}
