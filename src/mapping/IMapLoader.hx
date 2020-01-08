package mapping;

interface IMapLoader {
    function loadMapHeader():MapHeader;
    function loadMap():MapBody;
}
