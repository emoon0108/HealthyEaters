from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

OUT = Path(__file__).resolve().parents[1] / "assets" / "images"
OUT.mkdir(parents=True, exist_ok=True)

FONT_PATHS = [
    Path("/System/Library/Fonts/SFNS.ttf"),
    Path("/System/Library/Fonts/Geneva.ttf"),
]


def load_font(size):
    for path in FONT_PATHS:
        if path.exists():
            try:
                return ImageFont.truetype(str(path), size)
            except OSError:
                pass
    return ImageFont.load_default()


FONT_BIG = load_font(58)
FONT_MED = load_font(36)


def new(size=(256, 256)):
    return Image.new("RGBA", size, (0, 0, 0, 0))


def save(img, name):
    img.save(OUT / f"{name}.png")


def center_text(draw, xy, text, font, fill):
    x, y = xy
    box = draw.textbbox((0, 0), text, font=font)
    draw.text((x - (box[2] - box[0]) / 2, y - (box[3] - box[1]) / 2), text, font=font, fill=fill)


def icon_base(color=(255, 248, 214, 255)):
    img = new()
    d = ImageDraw.Draw(img)
    d.rounded_rectangle((18, 18, 238, 238), radius=44, fill=color, outline=(28, 84, 51, 255), width=5)
    return img, d


def apple():
    img, d = icon_base((255, 241, 230, 255))
    d.ellipse((70, 78, 188, 205), fill=(220, 54, 48, 255))
    d.ellipse((52, 102, 128, 205), fill=(230, 67, 52, 255))
    d.ellipse((128, 102, 204, 205), fill=(230, 67, 52, 255))
    d.rectangle((120, 46, 135, 90), fill=(105, 64, 34, 255))
    d.ellipse((136, 44, 190, 88), fill=(76, 156, 69, 255))
    d.ellipse((92, 100, 122, 130), fill=(255, 142, 128, 180))
    save(img, "food_apple")


def carrot():
    img, d = icon_base((255, 246, 222, 255))
    d.polygon([(87, 83), (187, 95), (129, 215)], fill=(240, 124, 38, 255))
    d.line((112, 124, 159, 132), fill=(194, 82, 26, 255), width=5)
    d.line((103, 154, 145, 162), fill=(194, 82, 26, 255), width=5)
    d.polygon([(116, 82), (78, 42), (122, 64)], fill=(66, 158, 76, 255))
    d.polygon([(128, 78), (130, 34), (154, 72)], fill=(76, 181, 82, 255))
    d.polygon([(139, 84), (185, 46), (160, 88)], fill=(51, 143, 70, 255))
    save(img, "food_carrot")


def broccoli():
    img, d = icon_base((237, 255, 232, 255))
    d.rounded_rectangle((110, 126, 148, 210), radius=16, fill=(90, 154, 78, 255))
    for box in [(62, 68, 132, 138), (107, 48, 179, 124), (139, 82, 205, 150), (83, 104, 162, 176)]:
        d.ellipse(box, fill=(40, 138, 72, 255))
    d.ellipse((114, 82, 172, 140), fill=(61, 169, 86, 255))
    save(img, "food_broccoli")


def yogurt():
    img, d = icon_base((238, 248, 255, 255))
    d.rounded_rectangle((70, 80, 186, 204), radius=22, fill=(245, 250, 255, 255), outline=(53, 122, 171, 255), width=5)
    d.rectangle((78, 96, 178, 132), fill=(95, 172, 224, 255))
    d.ellipse((98, 55, 158, 93), fill=(255, 255, 255, 255), outline=(53, 122, 171, 255), width=4)
    center_text(d, (128, 153), "Y", FONT_BIG, (53, 122, 171, 255))
    save(img, "food_yogurt")


def banana():
    img, d = icon_base((255, 251, 218, 255))
    d.arc((56, 60, 210, 214), 25, 205, fill=(242, 198, 38, 255), width=30)
    d.arc((70, 74, 194, 199), 25, 205, fill=(255, 226, 67, 255), width=24)
    d.ellipse((63, 174, 90, 202), fill=(117, 78, 35, 255))
    d.ellipse((182, 70, 208, 96), fill=(117, 78, 35, 255))
    save(img, "food_banana")


def strawberry():
    img, d = icon_base((255, 239, 244, 255))
    d.polygon([(128, 73), (72, 115), (94, 205), (128, 222), (162, 205), (184, 115)], fill=(225, 58, 75, 255))
    d.polygon([(128, 77), (95, 50), (118, 90)], fill=(57, 156, 73, 255))
    d.polygon([(128, 77), (162, 50), (138, 90)], fill=(57, 156, 73, 255))
    for xy in [(105, 120), (136, 125), (155, 154), (116, 165), (133, 191)]:
        d.ellipse((xy[0] - 4, xy[1] - 4, xy[0] + 4, xy[1] + 4), fill=(255, 235, 128, 255))
    save(img, "food_strawberry")


def milk():
    img, d = icon_base((236, 250, 255, 255))
    d.polygon([(82, 74), (174, 74), (190, 103), (190, 210), (66, 210), (66, 103)], fill=(255, 255, 255, 255), outline=(60, 132, 184, 255))
    d.polygon([(82, 74), (128, 42), (174, 74)], fill=(213, 238, 255, 255), outline=(60, 132, 184, 255))
    d.rectangle((80, 118, 176, 160), fill=(100, 184, 232, 255))
    center_text(d, (128, 139), "Milk", FONT_MED, (255, 255, 255, 255))
    save(img, "food_milk")


def rice():
    img, d = icon_base((255, 252, 235, 255))
    d.pieslice((54, 93, 202, 230), 0, 180, fill=(88, 160, 205, 255), outline=(34, 89, 128, 255), width=5)
    d.rectangle((54, 158, 202, 164), fill=(88, 160, 205, 255))
    for xy in [(90, 114), (122, 98), (154, 114), (110, 137), (144, 139)]:
        d.ellipse((xy[0] - 14, xy[1] - 9, xy[0] + 14, xy[1] + 9), fill=(255, 255, 250, 255), outline=(224, 224, 210, 255))
    save(img, "food_rice")


def chicken():
    img, d = icon_base((255, 244, 232, 255))
    d.ellipse((70, 100, 185, 185), fill=(240, 157, 80, 255), outline=(158, 89, 44, 255), width=5)
    d.ellipse((160, 75, 205, 121), fill=(255, 236, 213, 255), outline=(158, 89, 44, 255), width=4)
    d.rectangle((175, 113, 196, 153), fill=(255, 236, 213, 255))
    d.ellipse((58, 130, 105, 178), fill=(250, 184, 99, 255))
    save(img, "food_chicken")


def beans():
    img, d = icon_base((245, 255, 237, 255))
    for box, color in [
        ((75, 85, 126, 164), (104, 166, 76, 255)),
        ((116, 76, 167, 158), (72, 143, 88, 255)),
        ((95, 137, 150, 210), (97, 164, 79, 255)),
        ((143, 128, 194, 203), (74, 142, 86, 255)),
    ]:
        d.ellipse(box, fill=color, outline=(35, 96, 55, 255), width=4)
    save(img, "food_beans")


def plate():
    img, d = icon_base((250, 255, 240, 255))
    d.ellipse((50, 55, 206, 211), fill=(250, 250, 244, 255), outline=(32, 95, 63, 255), width=6)
    d.ellipse((83, 88, 173, 178), fill=(228, 242, 220, 255), outline=(32, 95, 63, 255), width=4)
    d.ellipse((84, 92, 118, 126), fill=(225, 63, 54, 255))
    d.ellipse((131, 91, 169, 128), fill=(44, 146, 72, 255))
    d.rounded_rectangle((91, 138, 161, 166), radius=10, fill=(238, 191, 73, 255))
    save(img, "plate_balanced")


def buddy():
    img = new((384, 384))
    d = ImageDraw.Draw(img)
    d.ellipse((58, 50, 326, 330), fill=(255, 230, 142, 255), outline=(38, 89, 55, 255), width=8)
    d.ellipse((118, 138, 148, 168), fill=(38, 70, 52, 255))
    d.ellipse((236, 138, 266, 168), fill=(38, 70, 52, 255))
    d.arc((135, 158, 250, 245), 20, 160, fill=(38, 70, 52, 255), width=8)
    d.ellipse((84, 176, 132, 218), fill=(255, 173, 128, 180))
    d.ellipse((252, 176, 300, 218), fill=(255, 173, 128, 180))
    d.polygon([(192, 20), (154, 62), (230, 62)], fill=(70, 167, 82, 255))
    d.ellipse((150, 28, 234, 78), fill=(61, 172, 82, 255))
    save(img, "buddy_food")


def arcade():
    img, d = icon_base((235, 247, 255, 255))
    d.rounded_rectangle((54, 70, 202, 190), radius=28, fill=(44, 108, 168, 255), outline=(25, 54, 91, 255), width=5)
    d.rectangle((78, 95, 178, 138), fill=(176, 232, 255, 255))
    d.ellipse((86, 156, 108, 178), fill=(255, 214, 75, 255))
    d.ellipse((144, 156, 166, 178), fill=(238, 92, 77, 255))
    d.line((128, 154, 128, 126), fill=(255, 245, 179, 255), width=8)
    d.ellipse((116, 112, 140, 136), fill=(255, 245, 179, 255))
    save(img, "icon_games")


def treasure():
    img, d = icon_base((255, 247, 222, 255))
    d.rounded_rectangle((58, 104, 198, 194), radius=20, fill=(189, 107, 49, 255), outline=(84, 50, 30, 255), width=5)
    d.pieslice((58, 58, 198, 150), 180, 360, fill=(235, 176, 65, 255), outline=(84, 50, 30, 255), width=5)
    d.rectangle((121, 102, 138, 194), fill=(255, 224, 92, 255))
    d.rounded_rectangle((112, 128, 147, 160), radius=6, fill=(255, 239, 128, 255), outline=(84, 50, 30, 255), width=3)
    for xy in [(84, 76), (169, 88), (100, 176), (179, 164)]:
        center_text(d, xy, "*", FONT_MED, (255, 251, 195, 255))
    save(img, "icon_rewards")


def parent():
    img, d = icon_base((242, 246, 255, 255))
    d.ellipse((83, 68, 145, 130), fill=(72, 132, 189, 255))
    d.ellipse((122, 58, 190, 126), fill=(238, 151, 105, 255))
    d.rounded_rectangle((66, 132, 159, 205), radius=34, fill=(72, 132, 189, 255))
    d.rounded_rectangle((112, 128, 207, 211), radius=36, fill=(238, 151, 105, 255))
    save(img, "icon_parent")


def token():
    img, d = icon_base((255, 250, 230, 255))
    d.ellipse((58, 58, 198, 198), fill=(255, 211, 61, 255), outline=(157, 107, 24, 255), width=8)
    d.ellipse((86, 86, 170, 170), fill=(255, 235, 118, 255), outline=(157, 107, 24, 255), width=4)
    center_text(d, (128, 125), "T", FONT_BIG, (117, 77, 18, 255))
    save(img, "icon_token")


def glossary():
    img, d = icon_base((240, 244, 255, 255))
    d.rounded_rectangle((72, 55, 184, 210), radius=12, fill=(92, 116, 207, 255), outline=(40, 56, 116, 255), width=5)
    d.rectangle((95, 55, 110, 210), fill=(255, 226, 101, 255))
    for y in [92, 124, 156]:
        d.line((124, y, 168, y), fill=(255, 255, 255, 255), width=5)
    save(img, "icon_glossary")


def heart_food():
    img, d = icon_base((255, 240, 245, 255))
    d.ellipse((72, 76, 132, 138), fill=(239, 80, 104, 255))
    d.ellipse((124, 76, 184, 138), fill=(239, 80, 104, 255))
    d.polygon([(73, 112), (183, 112), (128, 202)], fill=(239, 80, 104, 255))
    d.ellipse((111, 118, 145, 152), fill=(255, 230, 142, 255))
    d.rectangle((125, 98, 134, 122), fill=(111, 73, 35, 255))
    save(img, "icon_heart_food")


def mini_confetti():
    img = new((128, 128))
    d = ImageDraw.Draw(img)
    colors = [(255, 91, 91, 255), (255, 203, 72, 255), (70, 180, 120, 255), (81, 154, 236, 255), (172, 111, 232, 255)]
    pieces = [(20, 20), (56, 18), (98, 25), (35, 58), (72, 62), (108, 72), (18, 100), (61, 102), (95, 104)]
    for i, xy in enumerate(pieces):
        x, y = xy
        d.rounded_rectangle((x, y, x + 18, y + 10), radius=3, fill=colors[i % len(colors)])
    save(img, "decor_confetti")


def star():
    img = new((128, 128))
    d = ImageDraw.Draw(img)
    pts = [(64, 8), (78, 46), (119, 48), (86, 72), (98, 112), (64, 88), (30, 112), (42, 72), (9, 48), (50, 46)]
    d.polygon(pts, fill=(255, 216, 80, 255), outline=(152, 103, 21, 255))
    save(img, "decor_star")


def leaf():
    img = new((128, 128))
    d = ImageDraw.Draw(img)
    d.ellipse((18, 28, 112, 92), fill=(74, 170, 83, 255), outline=(31, 105, 56, 255), width=4)
    d.line((36, 83, 98, 38), fill=(31, 105, 56, 255), width=5)
    save(img, "decor_leaf")


for fn in [
    apple, carrot, broccoli, yogurt, banana, strawberry, milk, rice, chicken, beans,
    plate, buddy, arcade, treasure, parent, token, glossary, heart_food, star, leaf, mini_confetti,
]:
    fn()

print(f"Generated {len(list(OUT.glob('*.png')))} image assets in {OUT}")
