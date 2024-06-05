import './detail.css'
import { API, URL } from '../../config';
import axios from 'axios';
import { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';

const GetBookDetail = async (bookId) => {
    return await axios.get(API.GET_BOOK_DETAIL + "/" + bookId)
}

export const BookDetail = () => {
    const [loading, setLoading] = useState(false);
    const [BookItem, setBookItem] = useState(null);
    const { bookId } = useParams();

    useEffect(() => {
        GetBookDetail(bookId).then((detail) => {
            setBookItem(detail.data)
            setLoading(true)  
        }).catch((err) => {
            console.log(err)
            setLoading(false)
        })
        
        return () => {
            // console.log('componentWillUnmount[Function]')
        }
    }, [bookId]);

    if(loading === true) {
        const book = BookItem
        return (
            <>
            <div className="container">
                <h2 className='detailHeader'>도서 상세</h2>
                <article className="detail">
                    <div className="detailCover">
                        <img alt="이미지" src={URL.CDN + book.imageUrl} width="200px" height="300px"/>
                    </div>
                    <div className="detailDesc">
                        <div className="detailDescTitle">
                            <p>도서명 :</p>
                            <p>출판사 :</p>
                            <p>출판일 :</p>
                            <p>저자 :</p>
                        </div>
                        <div className="detailDescCont">
                            <p>{book.name}</p>
                            <p>{book.company}</p>
                            <p>{book.publishDate}</p>
                            <p>{book.writer}</p>
                        </div>
                    </div>
                </article>
            </div>
            </>
        );
    }
    return (
        <><h2> Loading...</h2>
        </>
    );
}