# ValueObject::JSONRPC

JSON-RPC 2.0 のメッセージを、作成後に変わらない値として表す小さな部品集。各リポジトリ（消費者）が共通で再利用するために存在する。

## Language

**値オブジェクト**:
作成後に変わらず、中身が等しければ等しいとみなされる、JSON-RPC 2.0 の構成要素（Version・Id・Request など）。
_Avoid_: DTO、エンティティ

**消費者**:
値オブジェクトを取り込んで使う側のリポジトリ。最初の消費者は p5-jsonrpc-client。
_Avoid_: 利用者、クライアント（JSON-RPC の client と紛れる）

**型の同一性**:
JSON の文字列 `"1"` と数値 `1` を別物として扱う規則。Id の突き合わせに必要。

**メッセージ**:
Request・Notification・SuccessResponse・ErrorResponse の総称。JSON-RPC 文字列全体が 1 つのメッセージ（または batch）に対応する。
_Avoid_: パケット、ペイロード

**Notification**:
id を持たず、応答を求めない Request。Request の id が null のものとは別物。

**不正な値**:
仕様に反する入力。構築時に、この名前空間内で定義したエラーオブジェクトとして表される。
_Avoid_: 無効値、バリデーションエラー
