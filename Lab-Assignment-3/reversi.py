def initialize():
    grid = []
    for i in range(8):
        grid.append([])
        for j in range(8):
            grid[i].append(None)
    
    return grid


def complete(grid):
    for i in grid:
        for j in grid[i]:
            if j==None: 
                return False
    return True


def verify(grid, user, coord):
    toflip = []

    if not onBoard(coord):
        return False
    grid[coord[0]][coord[1]] = user

    for xdirection, ydirection in [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]:
        x, y = coord[0], coord[1]
        x += xdirection
        y += ydirection

        if onBoard([x, y]) and grid[x][y]==(not user):
            x += xdirection
            y += ydirection
            if not onBoard([x, y]):
                continue
            while grid[x][y]==(not user):
                x += xdirection
                y += ydirection
                if not onBoard([x, y]):
                    break
            if not onBoard([x, y]):
                continue
            if grid[x][y]==user:
                while True:
                    x -= xdirection
                    y -= ydirection
                    if x == coord[0] and y == coord[1]:
                        break
                    toflip.append([x, y])

    grid[coord[0]][grid[1]] = None
    
    if len(toflip) == 0:
        return False
    return toflip



def onBoard(coord):
    for c in coord:
        if c < 0 or c > 7:
            return False
    return True


def main():
    grid = initialize()
    user = True

    while not complete(grid):
        coord = interaction(user)
        toflip = verify(grid, user, coord)

        if toflip:
            grid[coord[0]][coord[1]] = user
            for c in toflip:
                grid[c[0]][c[1]] = user
            user = not user
        else:
            print('Not a valid move! Try again.')
            continue


def interaction(user):
    if user:
        i = input('Player 1: Enter coordinate: ')
        ints = [int(x) for x in i.split(',')]
        return ints
    else:
        i = input('Player 2: Enter coordinate: ')
        ints = [int(x) for x in i.split(',')]
        return ints
