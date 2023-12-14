import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

class CounterViewController: UIViewController, View {

    typealias Reactor = CounterViewReactor
    var disposeBag = DisposeBag()
    
    init(reactor: CounterViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let minusButon: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        return button
    }()
    private let currentLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setView()
    }

    func bind(reactor: Reactor) {

        //Action
        minusButon.rx.tap
            .map { Reactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        plusButton.rx.tap
            .map { Reactor.Action.increase }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        //State
        reactor.state.map { $0.currentValue }
          .distinctUntilChanged()
          .map { "\($0)" }
          .bind(to: currentLabel.rx.text)
          .disposed(by: disposeBag)
    
    }

    func setView() {
        [
            minusButon,
            currentLabel,
            plusButton
        ].forEach { view.addSubview($0)}
        minusButon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(currentLabel.snp.leading).offset(-50)
            $0.width.height.equalTo(30)
        }
        currentLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        plusButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(currentLabel.snp.trailing).offset(50)
            $0.width.height.equalTo(30)
        }
    }
}
