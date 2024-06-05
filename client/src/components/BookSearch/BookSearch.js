import './search.css'
import { API } from '../../config';
import axios from 'axios';
import { useEffect, useState } from 'react';
import { Link, useParams } from 'react-router-dom';

const BookItem = (book, key) => {
    book = book.book
    return (
        <tr>
            <td>{book.bookId}</td>
            <td>
                <Link to={'/detail/' + book.bookId}>{book.name}</Link>
            </td>
            <td>{book.company}</td>
            <td>{book.publishDate}</td>
            <td>{book.writer}</td>
            <td>{book.status}</td>
        </tr>
    );
}

const FindBookItems = async (type, keyword) => {
    if(type === "도서명"){
        return await axios.get(API.FIND_BOOK_BY_NAME + "/" + keyword)
    }
    if(type === "카테고리"){
        return await axios.get(API.FIND_BOOK_BY_CATEGORY + "/" + keyword)
    }
    throw Object.assign(new Error(), {code: 404})
}

export const BookSearch = () => {
    const [loading, setLoading] = useState(false);
    const [BookItems, setBookItems] = useState([]);
    const { type, keyword } = useParams();

    useEffect(() => {
        FindBookItems(type, keyword).then((books) => {
            setBookItems(books.data)
            setLoading(true)
        }).catch((err) => {
            console.log(err)
            setLoading(false)
        })
    }, [type, keyword]);

    var cnt = 0
    if(loading === true) {
        return (
            <>
            <h2>검색 결과</h2>
            <div className="container">
                <table>
                    <colgroup>
                        <col width="150"/>
                        <col width="250"/>
                        <col width="150"/>
                        <col width="150"/>
                        <col width="150"/>
                        <col width="150"/>
                    </colgroup>
                    <thead>
                        <tr>
                            <th>도서코드</th>
                            <th>도서명</th>
                            <th>출판사</th>
                            <th>출판일</th>
                            <th>저자</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        {BookItems.map(book => <BookItem book={book} key={cnt++} />)}
                    </tbody>
                </table>
            </div>
            </>
        );
    }
    return (
        <><h2> Loading...</h2>
        </>
    );
}