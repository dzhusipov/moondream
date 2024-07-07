from fastapi import FastAPI, UploadFile, File, Form
from fastapi.responses import JSONResponse
from PIL import Image
from moondream import Moondream, detect_device, LATEST_REVISION
from transformers import AutoTokenizer
import torch
import io

app = FastAPI()

model_id = "vikhyatk/moondream2"
tokenizer = AutoTokenizer.from_pretrained(model_id, revision=LATEST_REVISION)
device, dtype = detect_device()
moondream = Moondream.from_pretrained(
    model_id,
    revision=LATEST_REVISION,
    torch_dtype=dtype,
).to(device=device)
moondream.eval()

@app.get("/")
async def read_root():
    return {"message": "World"}

@app.post("/describe_image/")
async def describe_image(file: UploadFile = File(...)):
    prompt = "Describe this image"
    image = Image.open(io.BytesIO(await file.read()))
    image_embeds = moondream.encode_image(image)

    if prompt:
        answer = moondream.answer_question(image_embeds, prompt, tokenizer)
        return JSONResponse(content={"prompt": prompt, "answer": answer})
    else:
        return JSONResponse(content={"error": "Prompt is required."})

# Run the app using the command: uvicorn server:app --host 0.0.0.0 --port 8080 --reload