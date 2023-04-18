import Foundation
//address information that will be obtained through a request
struct Address: Codable {
    let cep: String
    let logradouro: String
    let bairro: String
}
//compare two objects of type Address
extension Address: Equatable {
    static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.cep == rhs.cep && lhs.logradouro == rhs.logradouro && lhs.bairro == rhs.bairro
    }
}
