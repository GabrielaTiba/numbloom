/// Um desafio: número de 4 dígitos (1000 a 9999).
class ChallengeModel {
  const ChallengeModel(this.number);

  final int number;

  List<String> get digits => number.toString().padLeft(4, '0').split('');

  @override
  bool operator ==(Object other) =>
      other is ChallengeModel && other.number == number;

  @override
  int get hashCode => number.hashCode;
}