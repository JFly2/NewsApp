import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = NewsViewModel()
    @State private var selectedArticle: ArticleViewModel? = nil
    @State private var changeCountry = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                List(viewModel.articles) { article in
                    Button {
                        selectedArticle = article
                    } label: {
                        
                        
                        VStack(alignment: .leading, spacing: 3) {
                            
                            Text(article.source)
                                .fontWeight(.bold)
                            
                            Text(article.date)
                            
                            if let imageUrl = article.imageUrl {
                                HStack {
                                    Spacer()
                                AsyncImage(url: imageUrl) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(8)
                                        
                                    case .failure:
                                        Color.gray
                                        
                                    case .empty:
                                        ProgressView()
                                        
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .frame(width: 300, height: 200)
                                .clipped()
                                    Spacer()
                            }
                        }
                            
                            Text(article.cleanedTitle)
                                .fontWeight(.bold)
                            
                            Text(article.author)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray5))
                                .shadow(radius: 5)
                        )
                    }
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .onAppear {
                    viewModel.getNews()
                }
            }
            .navigationTitle("Top News")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            Picker("Category", selection: $viewModel.selectedCategory) {
                                ForEach(Category.allCases) { category in
                                    Text(category.displayName).tag(category)
                                }
                            }
                        } label: {
                            HStack {
                                Text("Category")
                                Image(systemName: "line.3.horizontal.decrease.circle")
                            }
                            .font(.subheadline)
                        }
                    }
                
                ToolbarItem(placement: .topBarTrailing){
                    Menu {
                        Picker("Country", selection: $viewModel.selectedCountry) {
                            ForEach(Country.countries) { country in
                                Text("\(country.flag) \(country.name)")
                                    .tag(country)
                            }
                        }
                    } label: {
                        Text(viewModel.selectedCountry.flag)
                    }
                }
            }
        }
        .sheet(item: $selectedArticle) { article in
            SafariView(url: article.url)
        }
    }
}

#Preview {
    ContentView()
}
