import UIKit
import MapKit

final class HomePageViewController: UIViewController {
    var viewModel = HomePageViewModel()
    
    var mapView: MKMapView!
    
    var userLocationPoints: [CLLocationCoordinate2D] = []
    
    var currentSessionPoints: [CLLocationCoordinate2D] = []

    var previousLocation: CLLocation?

    var locationManager: CLLocationManager?
    
    private var centerMeButton: SquareButtonView!
    
    private var followMeButton: SquareButtonView!
    
    private var resetButton: SquareButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        loadLocations()
    }
    
    private func setUI() {
        configureLocationManager()
        configureMapView()
        configureCenterMeButton()
        configureFollowMeButton()
        configureResetButton()
    }
    
    private func configureMapView() {
        mapView = MKMapView()
        mapView.pinToEdges(of: view)
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.requestLocation()
        locationManager?.startUpdatingLocation()
    }
    
    private func configureCenterMeButton() {
        centerMeButton = SquareButtonView()
        centerMeButton.configureView(imagePath: "location.fill")
        centerMeButton.didTap = zoomToCurrentLocation
        view.addSubview(centerMeButton)
        view.bringSubviewToFront(centerMeButton)
        NSLayoutConstraint.activate([
            centerMeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewModel.padding),
            centerMeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -viewModel.padding),
        ])
    }
    
    private func configureFollowMeButton() {
        followMeButton = SquareButtonView()
        followMeButton.configureView(imagePath: "scope")
        followMeButton.didTap = viewModel.toggleWillFollowUser
        view.addSubview(followMeButton)
        view.bringSubviewToFront(followMeButton)
        NSLayoutConstraint.activate([
            followMeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewModel.padding),
            followMeButton.bottomAnchor.constraint(equalTo: centerMeButton.topAnchor, constant: -viewModel.contentPadding),
        ])
    }
    
    private func configureResetButton() {
        resetButton = SquareButtonView()
        resetButton.configureView(imagePath: "xmark.circle",  tintColor: .red)
        resetButton.didTap = resetTrackedData
        view.addSubview(resetButton)
        view.bringSubviewToFront(resetButton)
        NSLayoutConstraint.activate([
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: viewModel.padding),
            resetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -viewModel.padding)
        ])
        
    }
    
    private func openSheetDialog(address: String) {
        let viewController = AdressSheetViewController()
        viewController.address = address
        let nav = UINavigationController(rootViewController: viewController)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        present(nav, animated: true)
    }
}

extension HomePageViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
           if let polyline = overlay as? MKPolyline {
               let renderer = MKPolylineRenderer(polyline: polyline)
               renderer.strokeColor = .blue
               renderer.lineWidth = 8.0
               return renderer
           }
           return MKOverlayRenderer(overlay: overlay)
       }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? CustomAnnotation,
           let address = annotation.address {
               openSheetDialog(address: address)
        }
        mapView.deselectAnnotation(view.annotation, animated: true)
    }
}

extension HomePageViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if viewModel.willFollowUser {
            drawLine(locations: locations)
            followCurrentLocation(where: locations)
            detectEveryHundredMeters(locations: locations)
            if !viewModel.isTracking {
                startTracking()
            }
        } else if viewModel.isTracking {
            stopTracking()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorizationThenZoomInCenter()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
}
