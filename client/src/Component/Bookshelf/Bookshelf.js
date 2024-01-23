import './shelf.css'
import { API, URL } from '../../config';
import axios from 'axios';
import { useEffect, useRef, useState } from 'react';
import { Link } from 'react-router-dom';

const BookCard = (data) => {
    const book = data.data
    return (
        <article className="item"><div className="card">
            <div className="bookCover">
                <Link to={'/detail/' + book.bookId}>
                    <img alt="이미지" src={URL.CDN + book.imageUrl} width="100px" height="150px"/>
                </Link>
            </div>
            <div className="bookDesc">
                <div className="bookTitle">{book.name}</div><br/>
                <div className="bookAuthor">{book.writer}</div>
                <div className="bookAuthor">{book.company}</div>
            </div>
        </div></article>
    );
}

const BookCards = async () => {
    return await axios.get(API.GET_ALL_BOOKS)
}

export const BookShelf = () => {
    const [loading, setLoading] = useState(false);
    const [BookItems, setBookItems] = useState([]);

    useEffect(() => {
        BookCards().then((books) => {
            setBookItems(books.data)
            setLoading(true)  
        }).catch((err) => {
            console.log(err)
            setLoading(false)
        })
        
        return () => {
        }
    }, []);

    const mounted = useRef(false);
    useEffect(() => {
        if(!mounted.current) {
            mounted.current = true;
        } else {
            
        }
    })

    var cnt = 0;
    if(loading === true) {
        return (
            <> <h2 className='shelfHeader' >추천 도서</h2>
            <div className="container"> 
                {BookItems.map((BookItem) => <BookCard data={BookItem} key={cnt++}/>)}
            </div></>
        );
    }
    return (
        <><h2> Loading...</h2>
        </>
    );
}