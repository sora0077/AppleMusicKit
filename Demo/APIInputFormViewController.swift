//
//  APIInputFormViewController.swift
//  Demo
//
//  Created by 林達也 on 2017/07/19.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import AppleMusicKit

protocol FormInput {
    var name: String { get }
    var `default`: Any? { get }
    var cellClass: UITableViewCell.Type { get }
}

extension FormInput {
    var cellIdentifier: String { return String(describing: cellClass) }
}

// MARK: Specific Input
struct TextInput: FormInput {
    let name: String
    let `default`: Any?
    var cellClass: UITableViewCell.Type { return TextInputCell.self }

    init(name: String, `default`: String? = nil) {
        self.name = name
        self.default = `default`
    }
}

struct IntInput: FormInput {
    let name: String
    let `default`: Any?
    var cellClass: UITableViewCell.Type { return IntInputCell.self }

    init(name: String, `default`: Int? = nil) {
        self.name = name
        self.default = `default`
    }
}

private final class ValueHolder {
    var value: Any?
    init(initial: Any?) {
        value = initial
    }
}

private class InputBaseCell: UITableViewCell {
    weak var valueHolder: ValueHolder?
    let titleLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {}

    func setValue(_ value: ValueHolder?, initial: Any?) {
        valueHolder = value
        updateValue(withInitial: initial)
    }

    func updateValue(withInitial initial: Any?) {}
}

private class TextInputCell: InputBaseCell {
    let textField = UITextField()

    override func setupViews() {
        super.setupViews()
        addSubview(textField)
        textField.textAlignment = .right
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.widthAnchor.constraint(greaterThanOrEqualToConstant: 170)])

        NotificationCenter.default.addObserver(
            self, selector: #selector(textFieldValueChanged),
            name: .UITextFieldTextDidChange, object: textField)
    }

    override func updateValue(withInitial initial: Any?) {
        textField.text = valueHolder?.value as? String ?? initial as? String
        textField.placeholder = valueHolder?.value == nil && initial == nil ? "nil" : ""
    }

    @objc
    func textFieldValueChanged() {
        valueHolder?.value = textField.text
    }
}

private final class IntInputCell: TextInputCell {
    override func textFieldValueChanged() {
        valueHolder?.value = Int(textField.text ?? "")
    }
}

extension APIInputFormViewController {
    struct Form {
        let title: String
        fileprivate let inputs: [FormInput]
        fileprivate let resultViewController: (APIInputFormViewController.FormData) -> UIViewController

        init<Req: Request, A: CustomStringConvertible, R>(
            _ inputs: [FormInput],
            _ request: @escaping (APIInputFormViewController.FormData) -> Req) where Req.Response == ResponseRoot<Resource<A, R>> {
            self.title = "\(Req.self)".components(separatedBy: "<").first ?? ""
            self.inputs = inputs
            resultViewController = { form in
                APIResultViewController(request: request(form))
            }
        }
        init(
            _ inputs: [FormInput],
            _ request: @escaping (APIInputFormViewController.FormData) -> SearchResources) {
            self.title = "\(SearchResources.self)".components(separatedBy: "<").first ?? ""
            self.inputs = inputs
            resultViewController = { form in
                APIResultViewController(request: request(form))
            }
        }
    }
    final class FormData {
        private let inputs: [FormInput]
        private let map: [String: FormInput]
        private var values: [String: ValueHolder] = [:]
        var count: Int { return inputs.count }

        init(inputs: [FormInput]) {
            self.inputs = inputs
            self.map = Dictionary(inputs.map { ($0.name, $0) },
                                  uniquingKeysWith: { first, _ in first })
            self.values = Dictionary(inputs.map { ($0.name, ValueHolder(initial: $0.default)) },
                                     uniquingKeysWith: { first, _ in first })
        }
        subscript <T>(key: String) -> T {
            get {
                func cast<T, U>(_ value: T, to: U.Type) -> U {
                    return value as! U
                }
                return cast(values[key]?.value, to: T.self)
            }
            set { values[key]?.value = newValue }
        }
        fileprivate subscript (index: Int) -> (FormInput, ValueHolder?) {
            let input = inputs[index]
            return (input, values[input.name])
        }
    }
}

protocol APIInputFormViewControllerDelegate: class {
    func inputFormViewController(_ vc: APIInputFormViewController,
                                 didFinishWithResultViewController resultVC: UIViewController)
}

final class APIInputFormViewController: UIViewController {
    weak var delegate: APIInputFormViewControllerDelegate?
    private let formData: FormData
    private let form: Form

    private let tableView = UITableView()

    init(form: Form) {
        self.formData = FormData(inputs: form.inputs)
        self.form = form
        super.init(nibName: nil, bundle: nil)
        for input in form.inputs {
            tableView.register(input.cellClass, forCellReuseIdentifier: input.cellIdentifier)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Results"
        view.backgroundColor = .white
        let doneButton = UIButton(type: .system)
        view.addSubview(tableView)
        view.addSubview(doneButton)

        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)])

        doneButton.setTitle("Request", for: .normal)
        doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        doneButton.layer.cornerRadius = 8
        doneButton.layer.borderWidth = 1
        doneButton.layer.borderColor = UIColor(hex: 0x7A69F2).cgColor
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4),
            doneButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4),
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -4),
            doneButton.heightAnchor.constraint(equalToConstant: 44)])

        let contentHeight = min(44 * CGFloat(formData.count) + 44 + 8, preferredContentSize.height)
        preferredContentSize.height = contentHeight
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAnimation()
    }

    private func showAnimation() {
        let view = popoverPresentationController?.presentedView
        view?.alpha = 0
        UIView.animate(withDuration: 0.2) {
            view?.alpha = 1
        }
    }

    @objc
    private func doneAction() {
        delegate?.inputFormViewController(
            self, didFinishWithResultViewController: form.resultViewController(formData))
    }
}

extension APIInputFormViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (input, value) = formData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: input.cellIdentifier,
                                                 for: indexPath) as! InputBaseCell
        cell.selectionStyle = .none
        cell.titleLabel.text = input.name
        cell.setValue(value, initial: input.default)
        return cell
    }
}
