// AddressViewModel.swift

import Foundation

class AddressViewModel {
    
    private let service: AddressService
    
    init(service: AddressService = AddressServiceImpl()) {
        self.service = service
    }
    //search for the address from the entered CEP code.
    func fetchAddress(cep: String, success: @escaping (Address) -> Void, failure: @escaping (Error) -> Void) {
        service.fetchAddress(cep: cep) { result in
            switch result {
            case .success(let address):
                success(address)
            case .failure(let error):
                failure(error)
            }
        }
    }
}
//methods that must be implemented by an address service class.
protocol AddressService {
    func fetchAddress(cep: String, completion: @escaping (Result<Address, Error>) -> Void)
}
//make a call to the ViaCEP API to fetch the address from the entered CEP code.
class AddressServiceImpl: AddressService {
    func fetchAddress(cep: String, completion: @escaping (Result<Address, Error>) -> Void) {
        let url = URL(string: "https://viacep.com.br/ws/\(cep)/json/")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                let error = NSError(domain: "AddressService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch address data"])
                completion(.failure(error))
                return
            }
            do {
                let address = try JSONDecoder().decode(Address.self, from: data)
                completion(.success(address))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}
