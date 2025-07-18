from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List
from datetime import date
from sqlalchemy import create_engine, Column, Integer, String, Float, Date
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# Configurações de conexão com o PostgreSQL
DATABASE_URL = "postgresql://abner:ofthekingthepowerthemendandthebesterdthekingthefarythesmain@node228824-my-fin-pg-db.sp1.br.saveincloud.net.br:11032/fin_db"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine)
Base = declarative_base()

# Modelo SQLAlchemy (banco de dados)
class TransacaoDB(Base):
    __tablename__ = "gastos"

    id = Column(Integer, primary_key=True, index=True)
    gasto = Column(String)
    valor_gasto = Column(Float)
    categoria = Column(String)
    data = Column(Date)

# Cria as tabelas se não existirem
#Base.metadata.create_all(bind=engine)

# Modelo Pydantic (entrada e saída da API)
class Transacao(BaseModel):
    gasto: str
    valor_gasto: float
    categoria: str
    data: date

    class Config:
        orm_mode = True,
        json_encoders = {
            date: lambda v: v.isoformat()
        }

app = FastAPI()

origins = [
    "http://localhost",
    "http://localhost:5000",
    "http://127.0.0.1:5000",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# GET - listar transações
@app.get("/transacoes", response_model=List[Transacao])
async def listar_transacoes():
    db = SessionLocal()
    transacoes = db.query(TransacaoDB).all()
    db.close()
    return transacoes

# POST - adicionar nova transação
@app.post("/transacoes", response_model=Transacao)
async def adicionar_transacao(transacao: Transacao):
    db = SessionLocal()
    nova_transacao = TransacaoDB(**transacao.dict())
    db.add(nova_transacao)
    db.commit()
    db.refresh(nova_transacao)
    db.close()
    return nova_transacao

# PUT - editar transação existente
@app.put("/transacoes/{id}", response_model=Transacao)
async def editar_transacao(id: int, transacao: Transacao):
    db = SessionLocal()
    transacao_db = db.query(TransacaoDB).filter(TransacaoDB.id == id).first()
    if not transacao_db:
        db.close()
        raise HTTPException(status_code=404, detail="Transação não encontrada")

    for key, value in transacao.dict().items():
        setattr(transacao_db, key, value)

    db.commit()
    db.refresh(transacao_db)
    db.close()
    return transacao_db


@app.get("/")
def read_root():
    return {"Hello": "World"}