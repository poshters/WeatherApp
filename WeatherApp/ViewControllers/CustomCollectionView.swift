import UIKit

protocol CustomCollectionViewDelegate: class {
    func didChangeOffsetY(_ offsetY: CGFloat)
    func didSelectRowAt(_ collectionView: UICollectionView, indexPath: IndexPath)
}

class CustomCollectionView: UIView {
    /// UI
    @IBOutlet private weak var collectionView: UICollectionView!
    
    /// Instance
    private var weathers = WeatherForecast()
    private let layout = UICollectionViewFlowLayout()
    private let header = HeaderView()
    weak var customCollectionDelegate: CustomCollectionViewDelegate?
    var scrollvIew = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonIinit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonIinit()
    }
    
    private func commonIinit() {
        Bundle.main.loadNibNamed(CustomCollectionView.className, owner: self, options: nil)
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: collectionView.trailingAnchor).isActive = true
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.scrollDirection = .horizontal
        collectionView.register(UINib.init(nibName: VerticallCollectionViewCell.className,
                                           bundle: nil),
                                forCellWithReuseIdentifier: VerticallCollectionViewCell.className)
        collectionView.register(UINib.init(nibName: HorizontalCollectionViewCell.className,
                                           bundle: nil),
                                forCellWithReuseIdentifier: HorizontalCollectionViewCell.className)
        collectionView.backgroundColor = UIColor.clear
        collectionView.reloadData()
    }
    
    /// Set weathers
    func fill(weathers: WeatherForecast) {
        self.weathers = weathers
        collectionView.reloadData()
    }
    
    @objc func refreshCollection() {
        collectionView.reloadData()
    }
    
    /// scroll
    func scrollChange() {
        if layout.scrollDirection == .horizontal {
            layout.scrollDirection = .vertical
        } else {
            layout.scrollDirection = .horizontal
        }
        self.collectionView.collectionViewLayout = layout
        let transition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        self.collectionView.layer.add(transition, forKey: nil)
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CustomCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weathers.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellWeatherDB = weathers.list[indexPath.row]
        if layout.scrollDirection == .horizontal {
            if let cell =
                collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCollectionViewCell.className,
                                                   for: indexPath) as? HorizontalCollectionViewCell {
                cell.accessToOutlet(date: DayOfWeeks.dayOfWeeks(date: cellWeatherDB.dateWeather,
                                                                separateDataAndDay: true),
                                    icon: cellWeatherDB.icon)
                cell.backgroundColor = UIColor.clear
                return cell
            }
        } else {
            if let cell =
                collectionView.dequeueReusableCell(withReuseIdentifier: VerticallCollectionViewCell.className,
                                                   for: indexPath) as? VerticallCollectionViewCell {
                cell.accessToOutlet(date: DayOfWeeks.dayOfWeeks(date: cellWeatherDB.dateWeather),
                                    desc: cellWeatherDB.desc,
                                    icon: cellWeatherDB.icon)
                cell.backgroundColor = UIColor.clear
                return cell
            }
        }
        return HorizontalCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        customCollectionDelegate?.didSelectRowAt(collectionView, indexPath: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CustomCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if layout.scrollDirection == .horizontal {
            let cellSize = CGSize(width: UIScreen.main.bounds.width * 0.16,
                                  height: UIScreen.main.bounds.height * 0.16)
            collectionView.reloadData()
            return cellSize
        } else {
            let cellSize = CGSize(width: UIScreen.main.bounds.width * 0.96,
                                  height: collectionView.bounds.height * 0.20)
            collectionView.reloadData()
            return cellSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if layout.scrollDirection == .horizontal {
            return UIScreen.main.bounds.width / 30
        } else {
            return collectionView.bounds.height / 25
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if layout.scrollDirection == .horizontal {
            let sectionInset = UIEdgeInsets(top: 200, left: UIScreen.main.bounds.width / 30,
                                            bottom: UIScreen.main.bounds.height / 2.6 ,
                                            right: UIScreen.main.bounds.width / 30)
            return sectionInset
        } else {
            let sectionInset = UIEdgeInsets(top: 200,
                                            left: UIScreen.main.bounds.width / 30,
                                            bottom: 10,
                                            right: UIScreen.main.bounds.width / 30)
            return sectionInset
        }
    }
}

// MARK: - UIScrollViewDelegate
extension CustomCollectionView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        customCollectionDelegate?.didChangeOffsetY(offsetY)
    }
}
