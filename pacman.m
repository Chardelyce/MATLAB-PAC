% Pac-Man Game in MATLAB with Clear Maze, Extra Lives, and Ghosts

% Initialize game parameters
boardSize = 15;
board = repmat(' ', boardSize, boardSize + 10); % Create an empty board with space for the score and lives

% Create a clear maze with '|' generated for the inside of the maze barriers
maze = [
    '|', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '|';
    '|', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '|';
    '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|';
    '|', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '|';
    '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|';
    '|', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '|';
    '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|';
    '|', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '|';
    '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|', '|';
    '|', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '|';
    '|', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '|';
];

% Place dots inside the maze, and two power-ups among the dots
dotPositions = [
    3, 4; 2, 6; 4, 8; 6, 5; 9, 3;
    4, 2; 5, 9; 8, 8; 9, 7; 10, 5;
];
powerUpPositions = [
    2, 3; 8, 5; % Add power-ups
];

% Initialize Pac-Man position within the maze
pacmanPos = [2, 2];

% Initialize ghost positions within the maze
initialGhostPositions = [
    2, 5; 7, 7; 8, 3; 10, 10;
];
ghostPositions = initialGhostPositions; % Store initial ghost positions

% Initialize Pac-Man state
pacmanOpen = true;

% Initialize Pac-Man direction
pacmanDirection = 'd';

% Initialize ghost movement delay
ghostDelay = 3; % Increase this value for slower ghost movement

% Initialize score
score = 0;

% Initialize lives
lives = 3; % Start with 3 lives

% Main game loop
gameOver = false;
while ~gameOver
    % Update the board
    board = repmat(' ', boardSize, boardSize + 10);
    
    % Place maze on the board
    board(1:size(maze, 1), 1:size(maze, 2)) = maze;
    
    if pacmanOpen
        board(pacmanPos(1), pacmanPos(2)) = 'C';
    else
        board(pacmanPos(1), pacmanPos(2)) = 'D';
    end
    pacmanOpen = ~pacmanOpen; % Toggle Pac-Man state
    
    % Place dots on the board within the maze
    for i = 1:size(dotPositions, 1)
        board(dotPositions(i, 1), dotPositions(i, 2)) = '.';
    end
    
    % Place power-ups on the board within the maze
    for i = 1:size(powerUpPositions, 1)
        board(powerUpPositions(i, 1), powerUpPositions(i, 2)) = 'O';
    end
    
    for i = 1:size(ghostPositions, 1)
        board(ghostPositions(i, 1), ghostPositions(i, 2)) = 'N';
    end
    
    % Display the score and lives to the right of the maze
    scoreStr = sprintf('Score: %d', score);
    livesStr = sprintf('Lives: %d', lives);
    board(1:size(scoreStr, 1), boardSize + 2:boardSize + 1 + length(scoreStr)) = scoreStr;
    board(3:size(livesStr, 1) + 2, boardSize + 2:boardSize + 1 + length(livesStr)) = livesStr;
    
    % Display the board
    clc; % Clear the console
    disp(board);
    
    % Check for user input
    direction = input('Enter direction (w/a/s/d/q to quit): ', 's');
    
    % Update Pac-Man's direction based on input
    switch direction
        case 'w'
            pacmanDirection = 'w';
        case 's'
            pacmanDirection = 's';
        case 'a'
            pacmanDirection = 'a';
        case 'd'
            pacmanDirection = 'd';
        case 'q'
            gameOver = true;
    end
    
    % Move ghosts towards Pac-Man with a delay
    if mod(ghostDelay, 2) == 0
        for i = 1:size(ghostPositions, 1)
            ghost = ghostPositions(i, :);
            if ghost(1) < pacmanPos(1)
                ghost(1) = ghost(1) + 1;
            elseif ghost(1) > pacmanPos(1)
                ghost(1) = ghost(1) - 1;
            end
            if ghost(2) < pacmanPos(2)
                ghost(2) = ghost(2) + 1;
            elseif ghost(2) > pacmanPos(2)
                ghost(2) = ghost(2) - 1;
            end
            ghostPositions(i, :) = ghost;
        end
    end
    ghostDelay = ghostDelay + 1;
    
    % Update Pac-Man's position based on direction and implement warping
    switch pacmanDirection
        case 'w'
            if pacmanPos(1) == 1
                pacmanPos(1) = size(maze, 1) - 1;
            else
                pacmanPos(1) = max(pacmanPos(1) - 1, 1);
            end
        case 's'
            if pacmanPos(1) == size(maze, 1) - 1
                pacmanPos(1) = 1;
            else
                pacmanPos(1) = min(pacmanPos(1) + 1, size(maze, 1) - 1);
            end
        case 'a'
            pacmanPos(2) = max(pacmanPos(2) - 1, 1);
        case 'd'
            pacmanPos(2) = min(pacmanPos(2) + 1, size(maze, 2) - 1);
    end
    
    % Check for collisions with dots, power-ups, ghosts, and extra lives
    for i = 1:size(dotPositions, 1)
        if isequal(dotPositions(i, :), pacmanPos)
            % Pac-Man ate a dot
            dotPositions(i, :) = [];
            score = score + 100;
            break;
        end
    end
    
    for i = 1:size(powerUpPositions, 1)
        if isequal(powerUpPositions(i, :), pacmanPos)
            % Pac-Man ate a power-up
            powerUpPositions(i, :) = [];
            
            % Check if there are ghosts to eat
            if ~isempty(ghostPositions)
                % Pac-Man can eat a ghost
                score = score + 200;
                % Remove the first ghost (Pac-Man can eat only one at a time)
                ghostPositions(1, :) = [];
            end
            
            break;
        end
    end
    
    for i = 1:size(ghostPositions, 1)
        if isequal(ghostPositions(i, :), pacmanPos)
            % Pac-Man collided with a ghost (game over if no extra lives)
            if lives > 0
                lives = lives - 1;
                pacmanPos = [2, 2];
                ghostPositions = initialGhostPositions; % Reset ghosts to initial positions
            else
                disp('Game over! Pac-Man got caught by a ghost and has no extra lives.');
                gameOver = true;
            end
            break;
        end
    end
    
    % Check for win condition
    if isempty(dotPositions) && isempty(powerUpPositions)
        disp('Level complete');
        gameOver = true;
    end
end

