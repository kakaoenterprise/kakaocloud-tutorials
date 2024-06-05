import "./Error.css"

export const Error = () => {
    return (
        <div className="error">
            <h1>Oops..!</h1>
            <p>지금 설정이나 접속 방식에 문제가 있는 것 같아요. </p>
            <p>다시 한번 확인해 주세요!</p>
            <img alt="라이언" src={process.env.PUBLIC_URL + "/assets/ryan_img.png"}/>
            <br/>
            <a href="/">홈으로 이동</a>
        </div>
    );
}