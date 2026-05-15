import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(AuthState.self) private var auth
    @Query private var obras: [ObraDeArte]
    @Query private var colecoes: [Colecao]
    @State private var showSettings = false
    @State private var showEditProfile = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    statsSection
                    Divider().padding(.vertical, 8)
                    obrasSection
                }
            }
            .navigationTitle("Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showEditProfile = true
                    } label: {
                        Text("Editar")
                            .font(.subheadline)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundStyle(.primary)
                    }
                }
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileView()
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.indigo, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 88, height: 88)
                Text(auth.initials)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)
            }

            VStack(spacing: 4) {
                Text(auth.displayName)
                    .font(.title2).bold()
                if !auth.handle.isEmpty {
                    Text(auth.handle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if !auth.bio.isEmpty {
                    Text(auth.bio)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.top, 2)
                }
            }
        }
        .padding(.top, 24)
        .padding(.bottom, 20)
    }

    private var statsSection: some View {
        HStack(spacing: 0) {
            statItem(valor: obras.count, label: "Obras")
            Divider().frame(height: 36)
            statItem(valor: colecoes.count, label: "Coleções")
            Divider().frame(height: 36)
            statItem(valor: 3, label: "Lances")
        }
        .padding(.bottom, 16)
    }

    private func statItem(valor: Int, label: String) -> some View {
        VStack(spacing: 2) {
            Text("\(valor)")
                .font(.title3).bold()
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var obrasSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Minhas Obras")
                .font(.headline)
                .padding(.horizontal)

            if obras.isEmpty {
                ContentUnavailableView(
                    "Nenhuma obra ainda",
                    systemImage: "paintbrush",
                    description: Text("Adicione obras às suas coleções para vê-las aqui.")
                )
                .padding(.top, 20)
            } else {
                let columns = [GridItem(.flexible(), spacing: 2), GridItem(.flexible(), spacing: 2)]
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(obras) { obra in
                        if let data = obra.image, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .aspectRatio(1, contentMode: .fill)
                                .clipped()
                        } else {
                            Rectangle()
                                .fill(Color(.systemGray5))
                                .aspectRatio(1, contentMode: .fill)
                        }
                    }
                }
            }
        }
        .padding(.top, 8)
    }
}
