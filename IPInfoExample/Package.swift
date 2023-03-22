// swift-tools-version:4.0
import PackageDescription // Модуль, в котором находится описание пакета

let package = Package(
    name: "IPInfoExample", // Имя нашего пакета
    products: [
        .library(
            name: "IPInfoExample",
            targets: ["IPInfoExample"]),
    ],
    dependencies: [
        // подключаем зависимость-пакет Alamofire, указываем ссылку на GitHub
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "IPInfoExample",
            // указываем целевой продукт – библиотеку, которая зависима
            // от библиотеки Alamofire
            dependencies: ["Alamofire"]),
        .testTarget(
            name: "IPInfoExampleTests",
            dependencies: ["IPInfoExample"]),
    ]
)
