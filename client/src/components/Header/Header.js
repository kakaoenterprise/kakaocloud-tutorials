import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import './header.css'

let searchTypes = [
    {value: '도서명', label: "도서명"},
    {value: '카테고리', label: "카테고리"}
];

const validateText = (text = "") => {
    if (text.length < 1) {
        return "$null";
    }
    return text;
}

export const Header = () => {
    const [Selected, setSelected] = useState(searchTypes[0].value)
    const [text, setText] = useState("")
    const navigate = useNavigate(); 

    const handleSelect = (event) => {
        setSelected(event.target.value);
    }

    const handleText = (event) => {
        setText(event.target.value);
    }

    const handleBtnClick = (event) => {
        const path = `/result/${Selected}/${validateText(text)}`
        navigate(path)
    }

    return (
        <header className="th">
            <div className="header">
                <Link to='/'>카카오클라우드 도서관</Link>
            </div>
            <nav>
                <img alt="라이언" src={process.env.PUBLIC_URL + "/assets/ryan_img.png"}/>
                <select className='searchSelect' required={true} onChange={handleSelect} value={Selected}>
                    <option value={searchTypes[0].value}> {searchTypes[0].label} </option>
                    <option value={searchTypes[1].value}> {searchTypes[1].label} </option>
                </select>
                <input className="searchBox" size="30" onChange={handleText} value={text} />
                <button className="searchButton" onClick={handleBtnClick} >도서 검색</button>
            </nav>
        </header>
    );
};