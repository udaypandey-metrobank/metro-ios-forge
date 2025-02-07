import SwiftUI

// Network Error Enum
enum NetworkError: Error {
    case failedRequest
}

// User Data Model
struct UserData {
    let firstName: String
    let lastName: String
    let age: Int
    let postCode: String
}

// Fake Network Service
class FakeNetworkService {
    static let shared = FakeNetworkService()
    
    func fetchFirstName() async throws -> String {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        if Int.random(in: 1...10) > 7 { throw NetworkError.failedRequest }
        return "John"
    }
    
    func fetchLastName() async throws -> String {
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        if Int.random(in: 1...10) > 7 { throw NetworkError.failedRequest }
        return "Doe"
    }
    
    func fetchAge() async throws -> Int {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        if Int.random(in: 1...10) > 7 { throw NetworkError.failedRequest }
        return 30
    }
    
    func fetchPostCode() async throws -> String {
        try? await Task.sleep(nanoseconds: 2_500_000_000)
        if Int.random(in: 1...10) > 7 { throw NetworkError.failedRequest }
        return "12345"
    }
    
    func fetchUserData() async throws -> UserData {
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        if Int.random(in: 1...10) > 7 { throw NetworkError.failedRequest }
        return UserData(firstName: "John", lastName: "Doe", age: 30, postCode: "12345")
    }
}

// ViewModel
class HelloViewModel: ObservableObject {
    @Published var userData: UserData? = nil
    @Published var errorMessage: String? = nil
    
    func fetchData() {
        Task {
            do {
                userData = try await FakeNetworkService.shared.fetchUserData()
            } catch {
                errorMessage = "Failed to load user data!"
            }
        }
    }
}

// SwiftUI View
struct ContentView: View {
    @StateObject private var viewModel = HelloViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            if let userData = viewModel.userData {
                Text("First Name: \(userData.firstName)")
                Text("Last Name: \(userData.lastName)")
                Text("Age: \(userData.age)")
                Text("Post Code: \(userData.postCode)")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                Text("Loading...")
            }
        }
        .font(.title)
        .padding()
        .onAppear {
            viewModel.fetchData()
        }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


