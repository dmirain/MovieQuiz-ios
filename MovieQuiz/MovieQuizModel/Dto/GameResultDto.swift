struct GameResultDto {
    let correctAnswers: Int
    let riddlesCount: Int

    var asPercentage: Double {
        Double(self.correctAnswers) / Double(self.riddlesCount) * 100.0
    }
}
