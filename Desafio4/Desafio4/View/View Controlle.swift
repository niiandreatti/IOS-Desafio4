import UIKit

class ViewController: UIViewController {
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureLayout()
    }
    
    //MARK: Properties
    
    private lazy var cepTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Digite seu CEP"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Enviar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var cepLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var streetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var neighborhoodLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - View Model : fetch address data from the typed CEP code
    private lazy var viewModel: AddressViewModel = {
        let viewModel = AddressViewModel()
        return viewModel
    }()
    
    //MARK: Helpers
    
    private func configureLayout() {
        view.addSubview(cepTextField)
        view.addSubview(sendButton)
        view.addSubview(cepLabel)
        view.addSubview(streetLabel)
        view.addSubview(neighborhoodLabel)
        configureUI()
    }
    
    private func configureUI() {
        let cepTextFieldConstraints = [
            cepTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cepTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            cepTextField.widthAnchor.constraint(equalToConstant: 200),
            cepTextField.heightAnchor.constraint(equalToConstant: 30)
        ]
        let sendButtonConstraints = [
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.topAnchor.constraint(equalTo: cepTextField.bottomAnchor, constant: 20),
            sendButton.widthAnchor.constraint(equalToConstant: 80),
            sendButton.heightAnchor.constraint(equalToConstant: 30)
        ]
        let cepLabelConstraints = [
            cepLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cepLabel.topAnchor.constraint(equalTo: sendButton.bottomAnchor, constant: 20)
        ]
        let streetLabelConstraints = [
            streetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            streetLabel.topAnchor.constraint(equalTo: cepLabel.bottomAnchor, constant: 10)
        ]
        let neighborhoodLabelConstraints = [
            neighborhoodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            neighborhoodLabel.topAnchor.constraint(equalTo: streetLabel.bottomAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(cepTextFieldConstraints + sendButtonConstraints + cepLabelConstraints + streetLabelConstraints + neighborhoodLabelConstraints)
    }
    
    //MARK: Objc
    
    @objc private func sendButtonTapped() {
        guard let cep = cepTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !cep.isEmpty else {
            return
        }
        viewModel.fetchAddress(cep: cep) { [weak self] address in
            DispatchQueue.main.async {
                self?.cepLabel.text = "CEP: \(address.cep)"
                self?.streetLabel.text = "Logradouro: \(address.logradouro)"
                self?.neighborhoodLabel.text = "Bairro: \(address.bairro)"
            }
        } failure: { error in
            // handle error
        }
    }
    
}
