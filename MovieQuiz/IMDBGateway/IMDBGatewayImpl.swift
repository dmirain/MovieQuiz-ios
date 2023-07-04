struct IMDBGatewayImpl: IMDBGateway {
    func movies() -> [IMDBMovie] {
        return [
            IMDBMovie(
                name: "The Godfather",
                rating: 9.2
            ),
            IMDBMovie(
                name: "The Dark Knight",
                rating: 9
            ),
            IMDBMovie(
                name: "Kill Bill",
                rating: 8.1
            ),
            IMDBMovie(
                name: "The Avengers",
                rating: 8
            ),
            IMDBMovie(
                name: "Deadpool",
                rating: 8
            ),
            IMDBMovie(
                name: "The Green Knight",
                rating: 6.6
            ),
            IMDBMovie(
                name: "Old",
                rating: 5.8
            ),
            IMDBMovie(
                name: "The Ice Age Adventures of Buck Wild",
                rating: 4.3
            ),
            IMDBMovie(
                name: "Tesla",
                rating: 5.1
            ),
            IMDBMovie(
                name: "Vivarium",
                rating: 5.8
            )
        ].shuffled()
    }
}
