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
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerSection
                    statsSection
                    Divider()
                        .background(Color.obskaHair)
                        .padding(.vertical, 8)
                    obrasSection
                }
            }
            .background(Color.obskaPaper)
            .navigationTitle("Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Editar") { showEditProfile = true }
                        .font(.system(size: 15))
                        .foregroundStyle(Color.obskaAccent)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    ObskaCircleButton(systemName: "gearshape") {
                        showSettings = true
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

    // MARK: - Header

    private var headerSection: some View {
        HStack(alignment: .top, spacing: 18) {
            // Square avatar with Fraunces initials
            ZStack {
                RoundedRectangle(cornerRadius: Obska.radiusAvatar)
                    .fill(Color.obskaElevated)
                    .overlay(
                        RoundedRectangle(cornerRadius: Obska.radiusAvatar)
                            .stroke(Color.obskaHair, lineWidth: 1)
                    )
                Text(auth.initials)
                    .font(.fraunces(38, weight: .medium))
                    .tracking(-1)
                    .foregroundStyle(Color.obskaAccent)
            }
            .frame(width: 88, height: 88)

            VStack(alignment: .leading, spacing: 4) {
                Text(auth.displayName)
                    .font(.fraunces(26))
                    .tracking(-0.4)
                    .foregroundStyle(Color.obskaInk)
                    .lineLimit(1)

                if !auth.handle.isEmpty {
                    Text(auth.handle.uppercased())
                        .font(.obskaMonoCaption(13))
                        .tracking(0.6)
                        .foregroundStyle(Color.obskaInk2)
                }

                if !auth.bio.isEmpty {
                    Text(auth.bio)
                        .font(.system(size: 13))
                        .foregroundStyle(Color.obskaInk)
                        .lineLimit(3)
                        .padding(.top, 6)
                }
            }
            .padding(.top, 4)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 20)
    }

    // MARK: - Stats

    private var statsSection: some View {
        HStack(spacing: 0) {
            statItem(valor: obras.count, label: "OBRAS")
            Divider().frame(height: 36).background(Color.obskaHair)
            statItem(valor: colecoes.count, label: "COLEÇÕES")
            Divider().frame(height: 36).background(Color.obskaHair)
            statItem(valor: obras.compactMap(\.preco).count, label: "LANCES")
        }
        .padding(.vertical, 14)
        .overlay(
            Rectangle().frame(height: 1).foregroundStyle(Color.obskaHair),
            alignment: .top
        )
        .overlay(
            Rectangle().frame(height: 1).foregroundStyle(Color.obskaHair),
            alignment: .bottom
        )
    }

    private func statItem(valor: Int, label: String) -> some View {
        VStack(spacing: 6) {
            Text("\(valor)")
                .font(.fraunces(22, weight: .medium))
                .foregroundStyle(Color.obskaInk)
            Text(label)
                .font(.obskaMonoCaption(10))
                .tracking(1.4)
                .foregroundStyle(Color.obskaInk2)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Obras Grid

    @ViewBuilder
    private var obrasSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Minhas obras")
                    .font(.fraunces(22))
                    .tracking(-0.3)
                    .foregroundStyle(Color.obskaInk)
                Spacer()
                Text("VER TODAS")
                    .font(.obskaMonoCaption(11))
                    .tracking(1.2)
                    .foregroundStyle(Color.obskaInk2)
            }
            .padding(.horizontal, 20)

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
                        ZStack(alignment: .bottomTrailing) {
                            if let data = obra.image, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Rectangle()
                                    .fill(Color.obskaElevated)
                                    .overlay(
                                        Image(systemName: "photo")
                                            .foregroundStyle(Color.obskaHair)
                                    )
                            }

                            if let preco = obra.preco {
                                Text(preco, format: .currency(code: "BRL").presentation(.narrow))
                                    .font(.obskaMonoCaption(9))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 3)
                                    .background(.black.opacity(0.45))
                                    .clipShape(RoundedRectangle(cornerRadius: 2))
                                    .padding(6)
                            }
                        }
                        .aspectRatio(1, contentMode: .fit)
                        .clipped()
                    }
                }
            }
        }
        .padding(.top, 8)
    }
}
