//
//  ContentView.swift
//  Renamed to SettingsTab

//  Created by Bojan Mijic on 18.12.23..
//

import SwiftUI



struct ContentView: View {
    var body: some View {
        NavigationView {
                VStack {
                    // App icon & name
                    AppIconTitleView()

                    // Rest of the content
                    PageBody()
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }




struct PageBody: View {
    @State private var isSoundEnabled = true
    @State private var isHapticsEnabled = true
    @State private var installDate = Date()
    @State private var tapCount = 61
    @State private var showAlert = false

    
    var body: some View {


        
        Form {
            
            Section(header: Text("Settings"), footer: Text("Customize your app settings")) {
                ToggleRow(label: "Sound", isOn: $isSoundEnabled, onImageName: "bell.fill", offImageName: "bell.slash")
                ToggleRow(label: "Haptics", isOn: $isHapticsEnabled, onImageName: "iphone.gen3.radiowaves.left.and.right", offImageName: "iphone.gen3.slash")
            }

            Section(header: Text("App info"), footer: Text("Information about your app")) {
                IconTextRow(label: "First install date", imageName: "calendar.badge.clock", text: formatDate(installDate))
                IconTextRow(label: "Tap count", imageName: "hand.tap.fill", text: "\(tapCount)")
                IconTextRow(label: "App version", imageName: "timer", text: "v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")")
            }

            Section {
                Button(action: {
                    // Perform action when the "Rate us" button is pressed
                    print("Rate us pressed!")
                }) {
                    IconTextRow(label: "Rate us", imageName: "star.fill", text: "")
                }
            }

            Section {
                Button(action: {
                    // Show the alert when the "Delete all scores" button is pressed
                    showAlert = true
                }) {
                    IconTextRow(label: "Delete all scores", imageName: "exclamationmark.triangle.fill", text: "")
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())
                .alert(isPresented: $showAlert) {
                    // Display the warning alert
                    Alert(
                        title: Text("Are you sure?"),
                        message: Text("This action will delete all stored scores. Are you sure you want to proceed?"),
                        primaryButton: .destructive(Text("Delete"), action: {
                            // Add your delete action here
                            print("Deleting all scores...")
                        }),
                        secondaryButton: .cancel()
                    )
                }
            }
        }
    }

    // Helper function to format the date
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}


struct AppIconTitleView: View {
    @State private var appIcon: UIImage? = nil
    
    var body: some View {
            
            Group {
                Image(uiImage: appIcon ?? UIImage(systemName: "questionmark")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .cornerRadius(20)
                
                
                Text("\(Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "")")
                    .font(.title)
                    .fontWeight(.bold)
                    
                
                Text("Created with a touch of AI magic")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(Color.gray)
            }
            .onAppear {
                appIcon = {
                    if let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
                       let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
                       let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String],
                       let lastIcon = iconFiles.last {
                        return UIImage(named: lastIcon)
                    }
                    return nil
                }()
            }
        }
    }





struct IconTextRow: View {
    let label: String
    let imageName: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .frame(width: 15) // Set a fixed size for the icons
                .foregroundColor(.blue)
                .padding(.trailing, 10) // Add padding between icon and text
            TextRow(label: label, text: text)
        }
        .fixedSize(horizontal: false, vertical: true) // Allow the HStack to grow horizontally
    }
}

struct TextRow: View {
    let label: String
    let text: String
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(text)
        }
    }
}




struct ToggleRow: View {
    let label: String
    @Binding var isOn: Bool
    let onImageName: String
    let offImageName: String
    
    var body: some View {
        HStack {
            Image(systemName: isOn ? onImageName : offImageName)
                .frame(width: 15) // Set a fixed size for the icons
                .foregroundColor(.blue)
                .padding(.trailing, 10) // Add padding between icon and text
            Toggle(label, isOn: $isOn)
        }
        .fixedSize(horizontal: false, vertical: true) // Allow the HStack to grow horizontally
    }
    
    
    
}
    
    
    #Preview {
        ContentView()
    }

